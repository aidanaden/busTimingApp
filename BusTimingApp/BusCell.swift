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
        lbl.font = UIFont.systemFont(ofSize: 44)
        return lbl
    }()
    
    lazy var nextBusButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(updateBusTimings), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        btn.titleLabel?.textAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 27)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        return btn
    }()
    
    let busActivityIndicator: MDCActivityIndicator = {
        let av = MDCActivityIndicator()
        av.alpha = 0
        av.cycleColors = [.white]
        av.translatesAutoresizingMaskIntoConstraints = false
        av.radius = CGFloat(14)
        return av
    }()
    
    let subsequentLbl: UILabel = {
        let subLbl = UILabel()
        subLbl.numberOfLines = 1
        subLbl.lineBreakMode = .byCharWrapping
        subLbl.font = UIFont.systemFont(ofSize: 15)
        subLbl.textColor = .white
        subLbl.textAlignment = .right
        return subLbl
    }()
    
    var busData: BusData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(busNumberLbl)
        addSubview(nextBusButton)
        addSubview(subsequentLbl)
        addSubview(busActivityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = busNumberLbl.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 125, heightConstant: 75)
        
        _ = nextBusButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 26, leftConstant: 0, bottomConstant: 0, rightConstant: -13, widthConstant: 100, heightConstant: 70)
        
        _ = subsequentLbl.anchor(nil, left: nil, bottom: nextBusButton.bottomAnchor, right: nextBusButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 20, widthConstant: 20, heightConstant: 20)
        
        
        busActivityIndicator.centerXAnchor.constraint(equalTo: nextBusButton.centerXAnchor, constant: -5).isActive = true
        busActivityIndicator.centerYAnchor.constraint(equalTo: nextBusButton.centerYAnchor).isActive = true
    }
    
    func populateCell(busData: BusData) {
        
        self.busData = busData
        busNumberLbl.text = busData.busNumber
        
        if let nextbustiming = busData.nextBusTiming, let subsequentbustiming = busData.subsequentBusTiming {
            
            nextBusButton.setTitle("\(nextbustiming)", for: .normal)
            subsequentLbl.text = subsequentbustiming
        }
    }
    
    func updateBusTimings() {
        
        busActivityIndicator.alpha = 1
        busActivityIndicator.startAnimating()
        nextBusButton.setTitle("", for: .normal)
        subsequentLbl.text = ""
        
        busData?.updateTimings(completed: { (completed) in
            
            if completed {
                
                DispatchQueue.main.async {
                    
                    self.busActivityIndicator.stopAnimating()
                    self.busActivityIndicator.alpha = 0
                    
                    if let nextbustiming = self.busData?.nextBusTiming, let subsequentbustiming = self.busData?.subsequentBusTiming {
                        self.nextBusButton.setTitle("\(nextbustiming)", for: .normal)
                        self.subsequentLbl.text = subsequentbustiming
                    }
                }
                
            }
        })
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
