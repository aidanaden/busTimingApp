//
//  BusCell.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftyJSON


class BusCell: UICollectionViewCell {
    
    let busNumberLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byCharWrapping
        lbl.font = UIFont.systemFont(ofSize: 28)
        return lbl
    }()
    
    lazy var nextBusButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(updateBusTimings), for: .touchUpInside)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        return btn
    }()
    
    var busData: BusData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(busNumberLbl)
        addSubview(nextBusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = busNumberLbl.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        _ = nextBusButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 26, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 125, heightConstant: 75)
    }
    
    func populateCell(busData: BusData) {
        
        self.busData = busData
        busNumberLbl.text = busData.busNumber
        if let nextbustiming = busData.nextBusTiming {
            
            nextBusButton.setTitle("\(nextbustiming)", for: .normal)
        }
    }
    
    func updateBusTimings() {
        
        busData?.updateTimings()
        if let nextbustiming = busData?.nextBusTiming {
            
            nextBusButton.setTitle("\(nextbustiming)", for: .normal)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
