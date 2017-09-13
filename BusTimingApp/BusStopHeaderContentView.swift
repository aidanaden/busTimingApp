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
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(searchBar)
        addSubview(titleCoverView)
        titleCoverView.addSubview(busTitleLbl)
        addSubview(coverView)
        coverView.addSubview(miniBusTitleLbl)
        
        setupSearchBarConstraints()
        setupTitleAndOverlay()
        setupOverlayView()
    }
    
    var searchBarHeightAnchor: NSLayoutConstraint?
    
    func setupSearchBarConstraints() {
        
        searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        searchBar.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        
        searchBarHeightAnchor = searchBar.heightAnchor.constraint(equalToConstant: 38)
        searchBarHeightAnchor?.isActive = true
    }
    
    var busTitleCoverBottomAnchor: NSLayoutConstraint?
    
    func setupTitleAndOverlay() {
        
        titleCoverView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleCoverView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleCoverView.topAnchor.constraint(equalTo: coverView.bottomAnchor).isActive = true
        
        busTitleCoverBottomAnchor = titleCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -62)
        busTitleCoverBottomAnchor?.isActive = true
        
        _ = busTitleLbl.anchor(nil, left: leftAnchor, bottom: titleCoverView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 18, bottomConstant: 8, rightConstant: 0, widthConstant: 225, heightConstant: 52)
    }
    
    func setupOverlayView() {
        
        _ = coverView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 72)
        
        _ = miniBusTitleLbl.anchor(coverView.topAnchor, left: coverView.leftAnchor, bottom: nil, right: nil, topConstant: 34, leftConstant: 151.5, bottomConstant: 0, rightConstant: 0, widthConstant: 78, heightConstant: 24)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
