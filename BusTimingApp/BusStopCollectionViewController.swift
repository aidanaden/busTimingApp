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
    
    var sbarHeight: CGFloat = 41
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.headerContentView.searchBar.placeholder = "Stop ID"
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
                    textField.layer.cornerRadius = CGFloat(sbarHeight/3)
                    textField.layer.masksToBounds = true
                    textField.setLeftPaddingPoints(4)
                    textField.alpha = height/41 
                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//                    textField.backgroundColor = UIColor.init(white: 0.87, alpha: 1)
                    textField.font = UIFont.systemFont(ofSize: 15)
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
    
    var titleLblAnchorConstant: CGFloat = 57
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidScroll(scrollView)
        
        // animate changes of nav bar when scrolling down certain level
        
        let contentOffsetY = scrollView.contentOffset.y
        print("content offset: \(contentOffsetY)")
        var opacity: CGFloat = 0
        let sbarOpacity: CGFloat = 1
        var titleMultiplier: CGFloat = 1
        let duration = Double(0)
        
        if contentOffsetY > -180 {
            headerContentView.searchBar.placeholder = ""
        }
        
        if contentOffsetY >= -180 && contentOffsetY < -139 { // upper limit of sbar
            
            sbarHeight = CGFloat(abs(contentOffsetY + 139))
//            headerContentView.searchBar.text = ""
        }
        
        if contentOffsetY >= -180 && contentOffsetY < -123 { // -123 is higher limit where nav bar line reaches title
            titleLblAnchorConstant = CGFloat(abs(contentOffsetY + 123)) // compensate by adding 123
        }
        
        if contentOffsetY > -123 {   // set title lbl bottom constraint to MIN value when dragged up
            titleLblAnchorConstant = 0
        }
        
        if contentOffsetY >= -72 { // set mini lbl opacity to 1 when nav bar becomes small
            opacity = 1
        }
        
        if contentOffsetY < -180 {  // set search bar height and title lbl bottom constraint to MAX VALUE
                                    // when dragged down
            sbarHeight = 41
            titleLblAnchorConstant = 57
            titleMultiplier = min(contentOffsetY / -180, 1.1)
        }
        
//        if sbarHeight <= 38 * 3/8 {
//            sbarOpacity = 0
//        }
        
        
        UIView.animate(withDuration: duration, animations: {
            print("title bar anchor height: \(-self.titleLblAnchorConstant)")
            print("Search bar height: \(self.sbarHeight)")
            
//          self.headerContentView.searchBarTextFieldIncreaseSize(height: sbarHeight)
            self.headerContentView.busTitleLbl.font = UIFont.systemFont(ofSize: 38 * titleMultiplier, weight: UIFontWeightBold)
            
            self.headerContentView.busTitleCoverBottomAnchor?.isActive = false
            self.headerContentView.busTitleCoverBottomAnchor?.constant = -(self.titleLblAnchorConstant)
            self.headerContentView.busTitleCoverBottomAnchor?.isActive = true
            
            self.headerContentView.searchBarHeightAnchor?.isActive = false
            self.headerContentView.searchBarHeightAnchor?.constant = self.sbarHeight
            self.headerContentView.searchBarHeightAnchor?.isActive = true
        })
        
        UIView.animate(withDuration: 0.25, animations: {
            self.headerContentView.miniBusTitleLbl.alpha = opacity
            self.headerContentView.searchBar.alpha = sbarOpacity
        })
        
      
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        headerViewController.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        
        let contentOffsetY = scrollView.contentOffset.y
        var offset: CGFloat = 0
        print(contentOffsetY)
        
        if !decelerate {
            
            if contentOffsetY < -99 && contentOffsetY > -152.5 {
                sbarHeight = 0
                titleLblAnchorConstant = 0
                offset = -123
            }
            
            if contentOffsetY <= -152.5 && contentOffsetY > -180 {
                sbarHeight = 41
                titleLblAnchorConstant = 57
                offset = -180
            }
            
            if contentOffsetY >= -99 && contentOffsetY < -72 {
                offset = -72
            }
            
            
            if contentOffsetY > -72 {
                return
            }
            
            if contentOffsetY <= -180 {
                offset = contentOffsetY
            }
            
            
            UIView.animate(withDuration: 0.225, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                //            self.headerContentView.searchBarTextFieldIncreaseSize(height: sbarHeight)
                self.headerContentView.busTitleCoverBottomAnchor?.isActive = false
                self.headerContentView.busTitleCoverBottomAnchor?.constant = -(self.titleLblAnchorConstant)
                self.headerContentView.busTitleCoverBottomAnchor?.isActive = true
                
                self.headerContentView.searchBarHeightAnchor?.isActive = false
                self.headerContentView.searchBarHeightAnchor?.constant = self.sbarHeight
                self.headerContentView.searchBarHeightAnchor?.isActive = true
                
                scrollView.contentOffset.y = offset
            }, completion: nil)
        }
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidEndDecelerating(scrollView)
//        let contentOffsetY = scrollView.contentOffset.y
//        var offset: CGFloat = 0
//        print(contentOffsetY)
//        
//        if contentOffsetY < -99 && contentOffsetY > -155 {
//            sbarHeight = 0
//            titleLblAnchorConstant = 0
//            offset = -123
//        }
//        
//        if contentOffsetY < -155 && contentOffsetY > -180 {
//            sbarHeight = 41
//            titleLblAnchorConstant = 57
//            offset = -180
//        }
//        
//        if contentOffsetY > -99 && contentOffsetY < -72 {
//            offset = -72
//        }
//        
//        
//        if contentOffsetY > -72 {
//            return
//        }
//        
//        if contentOffsetY <= -180 {
//            offset = contentOffsetY
//        }
//        
//        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
//            //            self.headerContentView.searchBarTextFieldIncreaseSize(height: sbarHeight)
//            self.headerContentView.busTitleCoverBottomAnchor?.isActive = false
//            self.headerContentView.busTitleCoverBottomAnchor?.constant = -(self.titleLblAnchorConstant)
//            self.headerContentView.busTitleCoverBottomAnchor?.isActive = true
//            
//            self.headerContentView.searchBarHeightAnchor?.isActive = false
//            self.headerContentView.searchBarHeightAnchor?.constant = self.sbarHeight
//            self.headerContentView.searchBarHeightAnchor?.isActive = true
//            
//            scrollView.contentOffset.y = offset
//        }, completion: nil)
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
        
//        let shadowLayer = CALayer()
//        shadowLayer.shadowOffset = CGSize(width: 1, height: 1)
//        shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowRadius = 1
        let customLayer = MDCShadowLayer()
        customLayer.elevation = CGFloat(0.5)
        customLayer.isShadowMaskEnabled = false
        headerView.shadowLayer = customLayer

        
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















