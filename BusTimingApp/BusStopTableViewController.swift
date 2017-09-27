 //
//  ViewController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import SwipeCellKit
import Alamofire

 class BusStopCollectionViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, SwipeTableViewCellDelegate {
    
    var busStopData = TempBusStopData()
    var buses = [BusData]()
    var storedBusArray = [TempBusData]()
    var busArray = [TempBusData]()
    
    let kANIMATEDURATION: Double = 0.325
    let kDAMPENING: CGFloat = 50
    let kSPRINGVELOCITY: CGFloat = 0
    
    private let busCellId = "BusCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupNavBar()
        setupSearchController()
        tableView.register(BusCell.self, forCellReuseIdentifier: busCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        hideKeyboard()
    }
    
    func setupNavBar() {
        
        let refreshNavButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateBusArrayTimings))
        navigationItem.rightBarButtonItem = refreshNavButton
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.title = "Timings"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return busArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let busData = busArray[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: busCellId, for: indexPath) as! BusCell
        cell.selectionStyle = .none
        cell.delegate = self
        
        if let busNumber = busData._busNumber, let nextBus = busData._nextBusTiming, let subBus = busData._subsequentBusTiming, let busURL = busData._busUrl, let stopNum = busData._stopNumber, let bookmarked = busData._bookmarked, let nextStanding = busData._nextStanding, let subStanding = busData._subStanding, let nextBusType = busData._nextBusType, let subBusType = busData._subBusType {
            
            cell.populateCell(busNumber: busNumber, nextBus: nextBus, subBus: subBus, busURL: busURL, stopNum: stopNum, bookMarked: bookmarked, nextStanding: nextStanding, subStanding: subStanding, nextBusType: nextBusType, subBusType: subBusType)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // UISEARCH RESULTS UPDATING DELEGATE
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        if let text = searchController.searchBar.text {
            if text.characters.count < 5 {
                return
            } else {
                setupStopData(id: text)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if text.characters.count < 5 {
                return
            } else {
                setupStopData(id: text)
            }
        }
    }
    
    // SWIPETABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            
            let tempBusData = self.busArray[indexPath.item]
            
            let bookmarkAction = SwipeAction(style: .default, title: nil, handler: { (swipeAction, indexPath) in
                if let bookmarkStatus = tempBusData._bookmarked {
                    let reverseBookmarkStatus = !bookmarkStatus
                    tempBusData._bookmarked = reverseBookmarkStatus
                    if reverseBookmarkStatus {
                        self.saveData(tempBusData: tempBusData)
                    } else {
                        self.deleteData(index: indexPath.item)
                    }
                }
            })

            if let bookmarkStatus = tempBusData._bookmarked {
                
                let title = bookmarkStatus ? "Delete" : "Bookmark"
                let backgroundColor = bookmarkStatus ? coolColor.delete.color :  coolColor.bookmarked.color
                let style = bookmarkStatus ? SwipeActionStyle.destructive : SwipeActionStyle.default
                setActionTitleAndBackgroundColor(bookmarkAction, title: title, backgroundColor: backgroundColor, swipeActionStyle: style)
            }

            bookmarkAction.hidesWhenSelected = true
            return [bookmarkAction]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
//        let percentageTarget = SwipeExpansionStyle.Target.percentage(0.5)
//        options.expansionStyle = SwipeExpansionStyle.selection
        options.backgroundColor = .clear
    
        return options
    }
    
    func setActionTitleAndBackgroundColor(_ action: SwipeAction, title: String, backgroundColor: UIColor, swipeActionStyle: SwipeActionStyle) {
        action.title = title
        action.backgroundColor = backgroundColor
        action.style = swipeActionStyle
    }
    
}
 
 














