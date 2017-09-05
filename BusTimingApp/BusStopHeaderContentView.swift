//
//  BusStopContentHeaderView.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents

class BusStopHeaderContentView: UIView {
    
    var searchBar: UISearchBar = {
        let sbar = UISearchBar()
        sbar.backgroundImage = UIImage()
        sbar.tintColor = .clear
        sbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sbar
    }()
    
    var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "icons8-Harambe the Gorilla Filled_50")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var bigLogoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "icons8-Harambe the Gorilla Filled_50")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let newHeight:CGFloat = 42
        
        for subView in searchBar.subviews {
            
            for subsubView in subView.subviews {
                
                if let textField = subsubView as? UITextField {
                    
                    var currentTextFieldBounds = textField.bounds
                    currentTextFieldBounds.size.height = newHeight
                    textField.bounds = currentTextFieldBounds
                    textField.borderStyle = UITextBorderStyle.roundedRect
                }
            }
        }
        
        backgroundColor = .white
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(bigLogoImage)
        addSubview(logoImage)
        addSubview(searchBar)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = bigLogoImage.anchor(nil, left: leftAnchor, bottom: searchBar.topAnchor, right: nil, topConstant: 0, leftConstant: bounds.width/2 - 65/2, bottomConstant: 5, rightConstant: 0, widthConstant: 65, heightConstant: 65)
        
        logoImage.center = CGPoint(x: bounds.width/2, y: 44)
        logoImage.bounds.size = CGSize(width: 38, height: 38)
        
        _ = searchBar.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 72)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
