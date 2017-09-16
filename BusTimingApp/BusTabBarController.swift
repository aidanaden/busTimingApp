//
//  BusTabBarController.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 1/9/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents


class BusTabBarController: MDCTabBarViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        loadTabBar()
    }
    
    
    func loadTabBar() {
        
        let tabBarItem1 = UITabBarItem(title: "Bus Timings", image: nil, tag: 0)
        let tabBaritem2 = UITabBarItem(title: "Bookmarks", image: nil, tag: 1)
        
        let firstVC = BusStopFlexibleHeaderContainerViewController()
        firstVC.tabBarItem = tabBarItem1
        let secondVC = BookmarksFlexibleHeaderContainerViewController()
        secondVC.tabBarItem = tabBaritem2
        
        viewControllers = [firstVC, secondVC]
        
        let childVC = viewControllers.first
        selectedViewController = childVC
        
        tabBar?.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
        tabBar?.selectedItemTintColor = .black
        tabBar?.unselectedItemTintColor = MDCPalette.grey.tint700
        tabBar?.inkColor = MDCPalette.blueGrey.tint100
    }
 
    
}




