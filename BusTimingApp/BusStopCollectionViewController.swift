 //
//  ViewController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents
import CoreData
import SwiftyJSON
import Material

class BusStopCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var headerViewController: MDCFlexibleHeaderViewController!
    let headerContentView = BusStopHeaderContentView(frame: CGRect.zero)
    var busStopData = TempBusStopData()
    var busArray = [TempBusData]()
    
    private let busCellId = "BusCellId"
    let itachBusUrl = "http://api.itachi1706.com/api/busarrival.php?BusStopID="
    
    func convertDateFormater(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        if let date = dateFormatter.date(from: date) {
            
            dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "SGT")
            let timeDifference = Int(date.timeIntervalSince(Date())/60)
            
            if timeDifference <= 0 {
                return "Arr"
            }
            
            return "\(timeDifference)"
        }
        
        return  ""
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        hideKeyboard()
        setupSearchBar()
        collectionView?.register(BusCell.self, forCellWithReuseIdentifier: busCellId)
        collectionView?.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let busData = busArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: busCellId, for: indexPath) as! BusCell
        
        if let busNumber = busData.busNumber, let nextBus = busData.nextBusTiming, let subBus = busData.subsequentBusTiming, let busURL = busData.busUrl, let stopNum = busData.stopNumber {
            
            cell.populateCell(busNumber: busNumber, nextBus: nextBus, subBus: subBus, busURL: busURL, stopNum: stopNum)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.bounds.width
        let cellHeight: CGFloat = 100

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidScroll(scrollView)
        
        // animate changes of nav bar when scrolling down certain level
        
        let contentOffsetY = scrollView.contentOffset.y
//        var opacity: CGFloat = 1
//        let logoOpacity: CGFloat = 1
//        var bigLogoOpacity: CGFloat = 1
        let duration = Double(0)
        var sbarHeight: CGFloat = 0
        
        
        if contentOffsetY >= -215 && contentOffsetY < -173 {
            
            sbarHeight = CGFloat(abs(contentOffsetY + 173))
        }
        
        if contentOffsetY < -215 {
            sbarHeight = 42
        }
        
        UIView.animate(withDuration: duration, animations: {
            
            print(sbarHeight)
            self.headerContentView.searchBarTextFieldIncreaseSize(height: sbarHeight)
            self.headerContentView.searchBar.layoutIfNeeded()
            self.headerContentView.searchBar.layoutSubviews()
        })
        
      
    }
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = 215
        } else {
            headerView.maximumHeight = 75
        }
        headerView.minimumHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeHeaderView()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func setupHeaderView() {
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = collectionView
        
//        let shadowLayer = CALayer()
//        shadowLayer.shadowRadius = 0
//        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowOpacity = 1
//        headerView.shadowLayer = shadowLayer
        
        headerView.maximumHeight = 215
        headerView.minimumHeight = 75
        headerView.backgroundColor = .white
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        headerContentView.frame = headerView.frame
        headerContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerView.addSubview(headerContentView)
    }
    
    func setupSearchBar() {
        headerContentView.searchBar.delegate = self
        headerContentView.layoutIfNeeded()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            
            if text.characters.count == 5 {
                self.busStopData.stopId = text
                setupStopData()
                collectionView?.reloadData()
                dismissKeyboard()
            }
        }
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        collectionView?.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        headerContentView.searchBar.endEditing(true)
    }
}















