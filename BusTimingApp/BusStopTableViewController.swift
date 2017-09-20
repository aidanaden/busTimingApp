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

 class BusStopCollectionViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, SwipeTableViewCellDelegate {
    
    var busStopData = TempBusStopData()
    var buses = [BusData]()
    var storedBusArray = [TempBusData]()
    var busArray = [TempBusData]()
    
    let kANIMATEDURATION: Double = 0.325
    let kDAMPENING: CGFloat = 50
    let kSPRINGVELOCITY: CGFloat = 0
    
    private let busCellId = "BusCellId"
    let itachBusUrl = "http://api.itachi1706.com/api/busarrival.php?BusStopID="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupNavBar()
        setupSearchController()
        tableView.register(BusCell.self, forCellReuseIdentifier: busCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Timings"
//        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
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
        
        if let busNumber = busData._busNumber, let nextBus = busData._nextBusTiming, let subBus = busData._subsequentBusTiming, let busURL = busData._busUrl, let stopNum = busData._stopNumber {
            
            cell.populateCell(busNumber: busNumber, nextBus: nextBus, subBus: subBus, busURL: busURL, stopNum: stopNum)
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
            setupStopData(id: text)
        }
    }
    
    // SWIPETABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let bookMark = SwipeAction(style: .default, title: "Bookmark", handler: { (swipeAction, indexPath) in
                let tempBusData = self.busArray[indexPath.item]
                self.saveData(tempBusData: tempBusData)
            })
            bookMark.hidesWhenSelected = true
            bookMark.title = "Bookmark"
            return [bookMark]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .reveal
        
        return options
    }
}
 
 














