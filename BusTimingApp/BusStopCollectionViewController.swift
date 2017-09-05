//
//  ViewController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents

class BusStopCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var headerViewController: MDCFlexibleHeaderViewController!
    let headerContentView = BusStopHeaderContentView(frame: CGRect.zero)
    let busStopData = BusStopData()
    
    private let busCellId = "BusCellId"
    
//    var stopNumber: String? {
//        didSet {
//            self.busStopData.readJSON(BusID: stopNumber!)
//        }
//    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        // set collection view controller background: self.collectionView.backgroundColor = 
        // register custom bus cells
        
        hideKeyboard()
        setupSearchBar()
        collectionView?.register(BusCell.self, forCellWithReuseIdentifier: busCellId)
        collectionView?.backgroundColor = UIColor(white: 0.97, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busStopData.busesData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let busData = busStopData.busesData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: busCellId, for: indexPath) as! BusCell
        cell.populateCell(busData: busData)
        
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
        var opacity: CGFloat = 1
        var logoOpacity: CGFloat = 0
        var bigLogoOpacity: CGFloat = 1
        let duration = 0.25
        
        print(contentOffsetY)
        
        if contentOffsetY > -168 {
            
            bigLogoOpacity = 0
        }
        
        if contentOffsetY > -140 {
            
            opacity = 0
            bigLogoOpacity = 0
        }
        
        if headerViewController.headerView.frame.height == 72 {
            logoOpacity = 1
        }
        
        UIView.animate(withDuration: duration, animations: {
            
            self.headerContentView.searchBar.alpha = opacity
            self.headerContentView.logoImage.alpha = logoOpacity
            self.headerContentView.bigLogoImage.alpha = bigLogoOpacity
        })
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
    
    func setupSearchBar() {
        headerContentView.searchBar.delegate = self
        headerContentView.searchBar.placeholder = "Bus Stop Id"
        headerContentView.searchBar.searchBarStyle = .minimal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.busStopData.stopId = text
            collectionView?.reloadData()
            dismissKeyboard()
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















