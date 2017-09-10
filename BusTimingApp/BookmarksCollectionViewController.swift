//
//  BookmarksCollectionViewController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 1/9/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents
import CoreData


class BookmarksCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerViewController: MDCFlexibleHeaderViewController!
    let headerContentView = BookmarkHeaderContentView()
    var busArray = [BusData]()
    
    private let busCellId = "BusCellId"
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        collectionView?.reloadData()
    }
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        loadData()
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let busData = busArray[indexPath.item]
        clearData(busData: busData)
        reloadAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.bounds.width
        let cellHeight: CGFloat = 100
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidScroll(scrollView)
        
        // animate changes of nav bar when scrolling down certain level
    }
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = 180
        } else {
            headerView.maximumHeight = 72
        }
        headerView.minimumHeight = 72
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeHeaderView()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupHeaderView() {
        
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = collectionView
        headerView.maximumHeight = 180
        headerView.minimumHeight = 72
        headerView.backgroundColor = .white
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        headerContentView.frame = headerView.frame
        headerContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerView.addSubview(headerContentView)
    }
}









