//
//  BusCell.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import SwipeCellKit

class BusCell: SwipeTableViewCell {
    
    let busNumberLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byCharWrapping
        lbl.font = UIFont.systemFont(ofSize: 44)
//        lbl.font = RobotoFont.regular(with: 44)
        return lbl
    }()
    
    lazy var nextBusButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(updateBusTimings), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
//        btn.titleLabel?.font = RobotoFont.regular(with: 32)
        btn.titleLabel?.textAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 27)
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        return btn
    }()
    
    let busActivityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.alpha = 0
        av.color = .white
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    let subsequentLbl: UILabel = {
        let subLbl = UILabel()
        subLbl.numberOfLines = 1
        subLbl.lineBreakMode = .byCharWrapping
        subLbl.font = UIFont.systemFont(ofSize: 15)
//        subLbl.font = RobotoFont.regular(with: 15)
        subLbl.textColor = .white
        subLbl.textAlignment = .right
        return subLbl
    }()
    
    var busURL: String?
    var busNumber: String?
    var stopNumber: String?
    var nextBusTiming: String?
    var subBusTiming: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(busNumberLbl)
        addSubview(nextBusButton)
        addSubview(subsequentLbl)
        addSubview(busActivityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _ = busNumberLbl.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: frame.height/2 - 75/2, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 125, heightConstant: 75)
        
        _ = nextBusButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: frame.height/2 - 70/2, leftConstant: 0, bottomConstant: 0, rightConstant: -18, widthConstant: 100, heightConstant: 70)
        
        _ = subsequentLbl.anchor(nil, left: nil, bottom: nextBusButton.bottomAnchor, right: nextBusButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 22, widthConstant: 20, heightConstant: 20)
        
        
        busActivityIndicator.centerXAnchor.constraint(equalTo: nextBusButton.centerXAnchor, constant: -5).isActive = true
        busActivityIndicator.centerYAnchor.constraint(equalTo: nextBusButton.centerYAnchor).isActive = true
        
        
    }
    
    func populateCell(busNumber: String, nextBus: String, subBus: String, busURL: String, stopNum: String) {
        
        self.busNumber = busNumber
        self.nextBusTiming = nextBus
        self.subBusTiming = subBus
        self.busURL = busURL
        self.stopNumber = stopNum
        
        busNumberLbl.text = busNumber
            
        nextBusButton.setTitle("\(nextBus)", for: .normal)
        subsequentLbl.text = subBus
        
    }
    
    @objc func updateBusTimings() {
        
        busActivityIndicator.alpha = 1
        busActivityIndicator.startAnimating()
        nextBusButton.setTitle("", for: .normal)
        subsequentLbl.text = ""
        
        guard let busUrl = busURL, let stopID = stopNumber, let busNO = busNumber else { return }
        
        updateTimings(busURLString: busUrl, stopId: stopID, busNumber: busNO) { (completed) in
            if completed {
                
                DispatchQueue.main.async {
                    
                    self.busActivityIndicator.stopAnimating()
                    self.busActivityIndicator.alpha = 0
                    
                    if let nextbustiming = self.nextBusTiming, let subsequentbustiming = self.subBusTiming {
                        self.nextBusButton.setTitle("\(nextbustiming)", for: .normal)
                        self.subsequentLbl.text = subsequentbustiming
                    }
                }
                
            }
        }
    
    }
    
    func updateTimings(busURLString: String, stopId: String, busNumber: String, completed: @escaping (_ downloadComplete: Bool) -> Void) {
        
        var json: JSON!
        
        DispatchQueue.global().async {
            
            do {
                
                let urlString = busURLString + stopId + "&ServiceNo=" + busNumber
                guard let url = URL(string: urlString) else { return }
                let data = try Data(contentsOf: url)
                json = JSON(data: data)
                
            } catch _ {
                print("Couldn't update bus timings!")
            }
            
            let busesDictionary = json["Services"].arrayValue
            for bus in busesDictionary {
                
                let durationDate = bus["NextBus"]["EstimatedArrival"].stringValue
                let subsequentDate = bus["SubsequentBus"]["EstimatedArrival"].stringValue
                
                self.nextBusTiming = self.convertDateFormater(date: durationDate)
                self.subBusTiming = self.convertDateFormater(date: subsequentDate)
                
                completed(true)
            }
        }
    }

    
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


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
