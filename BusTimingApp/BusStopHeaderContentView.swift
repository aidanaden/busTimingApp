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
        sbar.translatesAutoresizingMaskIntoConstraints = false
        sbar.backgroundImage = UIImage()
        sbar.layer.cornerRadius = 12
        sbar.masksToBounds = true

        return sbar
    }()
    
    let busTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 42)
        lbl.text = "Timings"
        return lbl
    }()
    
    let miniBusTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.text = "Timings"
        lbl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return lbl
    }()
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(busTitleLbl)
        addSubview(searchBar)
        addSubview(coverView)
        coverView.addSubview(miniBusTitleLbl)
        
        setupSearchBarConstraints()
        setupTitleLbl()
        setupOverlayView()
    }
    
    var searchBarHeightAnchor: NSLayoutConstraint?
    
    func setupSearchBarConstraints() {
        
        searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        searchBar.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        
        searchBarHeightAnchor = searchBar.heightAnchor.constraint(equalToConstant: 42)
        searchBarHeightAnchor?.isActive = true
    }
    
    func setupTitleLbl() {
        _ = busTitleLbl.anchor(nil, left: leftAnchor, bottom: searchBar.topAnchor, right: nil, topConstant: 0, leftConstant: 18, bottomConstant: 8, rightConstant: 0, widthConstant: 225, heightConstant: 52)
    }
    
    func setupOverlayView() {
        
        _ = coverView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 72)
        
        _ = miniBusTitleLbl.anchor(coverView.topAnchor, left: coverView.leftAnchor, bottom: nil, right: nil, topConstant: 34, leftConstant: 151.5, bottomConstant: 0, rightConstant: 0, widthConstant: 78, heightConstant: 24)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBarTextFieldIncreaseSize(height: 42)
        
    }
    
    
    func searchBarTextFieldIncreaseSize(height: CGFloat) {
        
        self.searchBar.layoutIfNeeded()
        self.searchBar.layoutSubviews()
        
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
