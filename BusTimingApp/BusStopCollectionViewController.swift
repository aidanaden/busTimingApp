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
    
    var sbarHeight: CGFloat = 38
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        searchBarTextFieldIncreaseSize(height: sbarHeight)
    }
    
    func searchBarTextFieldIncreaseSize(height: CGFloat) {
        
        headerContentView.searchBar.layoutIfNeeded()
        headerContentView.searchBar.layoutSubviews()
        
        for subView in headerContentView.searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = height //(set height whatever you want)
                    textField.bounds = bounds
                    textField.cornerRadius = CGFloat(12.5)
                    textField.masksToBounds = true
                    textField.setLeftPaddingPoints(5)
                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                    textField.backgroundColor = UIColor.init(white: 0.89, alpha: 1)
                    //                    textField.font = UIFont.systemFontOfSize(20)
                }
            }
        }
        
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
        print(contentOffsetY)
        var opacity: CGFloat = 0
        var sbarOpacity: CGFloat = 1
//        let logoOpacity: CGFloat = 1
//        var bigLogoOpacity: CGFloat = 1
        let duration = Double(0)
        
        headerContentView.searchBar.placeholder = "Stop ID"
        
        if contentOffsetY > -190 {
            headerContentView.searchBar.placeholder = ""
        }
        
        if contentOffsetY >= -190 && contentOffsetY < -152 {
            
            sbarHeight = CGFloat(abs(contentOffsetY + 152))
            headerContentView.searchBar.text = ""
        }
        
        if contentOffsetY > -72 {
            opacity = 1
        }
        
        if contentOffsetY < -190 {
            sbarHeight = 38
        }
        
        if sbarHeight <= 38 * 3/8 {
            sbarOpacity = 0
        }
        
        UIView.animate(withDuration: duration, animations: {
            print(self.sbarHeight)
            
//            self.headerContentView.searchBarTextFieldIncreaseSize(height: sbarHeight)
            self.headerContentView.searchBarHeightAnchor?.isActive = false
            self.headerContentView.searchBarHeightAnchor?.constant = self.sbarHeight
            self.headerContentView.searchBarHeightAnchor?.isActive = true
        })
        
        UIView.animate(withDuration: 0.25, animations: {
            self.headerContentView.miniBusTitleLbl.alpha = opacity
            self.headerContentView.searchBar.alpha = sbarOpacity
        })
        
      
    }
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = 190
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
        
//        let shadowLayer = CALayer()
//        shadowLayer.shadowRadius = 5
//        shadowLayer.shadowOffset = CGSize(width: 0, height: 5)
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowOpacity = 1
        let customLayer = MDCShadowLayer()
        customLayer.elevation = CGFloat(0.5)
        customLayer.isShadowMaskEnabled = false
        headerView.shadowLayer = customLayer
        
        headerView.maximumHeight = 190
        headerView.minimumHeight = 78
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















