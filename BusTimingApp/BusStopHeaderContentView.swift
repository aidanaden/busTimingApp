//
//  BusStopContentHeaderView.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents
import Material

class BusStopHeaderContentView: UIView {
    
    var searchBar: UISearchBar = {
        let sbar = UISearchBar()

        sbar.placeholder = "Stop ID"
        sbar.tintColor = .lightGray
        
    
        sbar.backgroundImage = UIImage()

        return sbar
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(searchBar)
        
        _ = searchBar.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 14, widthConstant: 0, heightConstant: 58)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBarTextFieldIncreaseSize(height: 42)
    }
    
    
    func searchBarTextFieldIncreaseSize(height: CGFloat) {
        
        self.searchBar.layoutSubviews()
        self.searchBar.layoutIfNeeded()
        
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = height //(set height whatever you want)
                    textField.bounds = bounds
                    textField.cornerRadius = CGFloat(12)
                    textField.masksToBounds = true
                    textField.setLeftPaddingPoints(5)
                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                    textField.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
                    //                    textField.font = UIFont.systemFontOfSize(20)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
