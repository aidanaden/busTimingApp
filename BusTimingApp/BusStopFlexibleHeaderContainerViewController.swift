//
//  BusStopFlexibleHeaderContainerViewController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents

class BusStopFlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let collectionVC = BusStopCollectionViewController(collectionViewLayout: layout)
        super.init(contentViewController: collectionVC)
        collectionVC.headerViewController = self.headerViewController
        collectionVC.setupHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




