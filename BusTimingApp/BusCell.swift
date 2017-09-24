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
import Alamofire

class BusCell: SwipeTableViewCell {
    
    let busNumberLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byCharWrapping
        lbl.font = UIFont.systemFont(ofSize: 44)
//        lbl.font = RobotoFont.regular(with: 44)
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
    
    let busIdLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byCharWrapping
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .darkGray
        lbl.alpha = 0.7
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var busURL: String?
    var busNumber: String?
    var stopNumber: String?
    var nextBusTiming: String?
    var subBusTiming: String?
    var nextStanding: String?
    var subStanding: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(busNumberLbl)
        addSubview(busIdLbl)
        addSubview(nextBusButton)
        addSubview(subsequentLbl)
        addSubview(busActivityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        _ = busNumberLbl.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: frame.height/2 - 75/2, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 85, heightConstant: 75)
        
        busNumberLbl.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/2 - 75/2 + 2).isActive = true
        busNumberLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        busNumberLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 75).isActive = true
        busNumberLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 90).isActive = true
        
//        _ = busIdLbl.anchor(nil, left: busNumberLbl.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 18, rightConstant: 0, widthConstant: 65, heightConstant: 32)
        busIdLbl.leadingAnchor.constraint(equalTo: busNumberLbl.leadingAnchor, constant: 4).isActive = true
        busIdLbl.topAnchor.constraint(equalTo: busNumberLbl.bottomAnchor, constant: 0).isActive = true
        busIdLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
        busIdLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 58).isActive = true
        
        _ = nextBusButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: frame.height/2 - 70/2, leftConstant: 0, bottomConstant: 0, rightConstant: -18, widthConstant: 100, heightConstant: 70)
        
        _ = subsequentLbl.anchor(nil, left: nil, bottom: nextBusButton.bottomAnchor, right: nextBusButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 22, widthConstant: 20, heightConstant: 20)
        
        
        busActivityIndicator.centerXAnchor.constraint(equalTo: nextBusButton.centerXAnchor, constant: -5).isActive = true
        busActivityIndicator.centerYAnchor.constraint(equalTo: nextBusButton.centerYAnchor).isActive = true
        
        
    }
    
    func populateCell(busNumber: String, nextBus: String, subBus: String, busURL: String, stopNum: String, bookMarked: Bool, nextStanding: String, subStanding: String) {
        
        self.busNumber = busNumber
        self.nextBusTiming = nextBus
        self.subBusTiming = subBus
        self.busURL = busURL
        self.stopNumber = stopNum
        self.nextStanding = nextStanding
        self.subStanding = subStanding
        
        busNumberLbl.text = busNumber
        busIdLbl.text = stopNum
        checkStandingStatusButton(busTiming: nextBus, standingStatus: nextStanding, nextBtn: nextBusButton)
        checkStandingStatusLabel(busTiming: subBus, standingStatus: subStanding, subLbl: subsequentLbl)
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
                    
                    if let nextbustiming = self.nextBusTiming, let subsequentbustiming = self.subBusTiming, let nextStanding = self.nextStanding, let subStanding = self.subStanding {
                        
                        self.checkStandingStatusButton(busTiming: nextbustiming, standingStatus: nextStanding, nextBtn: self.nextBusButton)
                        
                        self.checkStandingStatusLabel(busTiming: subsequentbustiming, standingStatus: subStanding, subLbl: self.subsequentLbl)
                        
                        self.nextBusButton.setTitle("\(nextbustiming)", for: .normal)
                        self.subsequentLbl.text = subsequentbustiming
                    }
                }
            }
        }
    
    }
    
    func updateTimings(busURLString: String, stopId: String, busNumber: String, completed: @escaping (_ downloadComplete: Bool) -> Void) {
        
        DispatchQueue.global().async {
            
            let urlString = dataUrl + stopId + busParameter + busNumber
            guard let url = URL(string: urlString) else { return }
            let parameters = ["AccountKey" : apiKey,
                              "accept" : "application/json"]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: parameters ).responseJSON(completionHandler: { (response) in
                if let data = response.result.value as? [String: Any] {
                    
                    let busesDictionary = data["Services"] as! [[String: Any]]
                    
                    for bus in busesDictionary {
                        
                        
                        let nextBus = bus["NextBus"] as! [String: String]
                        let subsequentBus = bus["NextBus2"] as! [String: String]
                        let nextBusDate = nextBus["EstimatedArrival"] as! String
                        let subsequentBusDate = subsequentBus["EstimatedArrival"] as! String
                        
                        self.nextBusTiming = convertDateFormater(date: nextBusDate)
                        self.subBusTiming = convertDateFormater(date: subsequentBusDate)
                        self.nextStanding = nextBus["Load"] as! String
                        self.subStanding = subsequentBus["Load"] as! String
                        
                        completed(true)
                    }
                }
            })
            
        }
    }
    
    
    
    func checkStandingStatusButton(busTiming: String, standingStatus: String, nextBtn: UIButton) {

        if busTiming == "Arr" {
            if standingStatus == "SEA" {
                nextBtn.setTitleColor(.green, for: .normal)
            } else if standingStatus == "SDA" {
                nextBtn.setTitleColor(.yellow, for: .normal)
            } else if standingStatus == "LSD" {
                nextBtn.setTitleColor(.red, for: .normal)
            }
        } else if standingStatus != "Arr" {
            if Int(busTiming)! <= 2 {
                if standingStatus == "SEA" {
                    nextBtn.setTitleColor(.green, for: .normal)
                } else if standingStatus == "SDA" {
                    nextBtn.setTitleColor(.yellow, for: .normal)
                } else if standingStatus == "LSD" {
                    nextBtn.setTitleColor(.red, for: .normal)
                }
            } else {
                nextBtn.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func checkStandingStatusLabel(busTiming: String, standingStatus: String, subLbl: UILabel) {
        if busTiming == "Arr" {
            if standingStatus == "SEA" {
                subLbl.textColor = .green
            } else if standingStatus == "SDA" {
                subLbl.textColor = .yellow
            } else if standingStatus == "LSD" {
                subLbl.textColor = .red
            }
        } else if standingStatus != "Arr" {
            if Int(busTiming)! <= 2 {
                if standingStatus == "SEA" {
                    subLbl.textColor = .green
                } else if standingStatus == "SDA" {
                    subLbl.textColor = .yellow
                } else if standingStatus == "LSD" {
                    subLbl.textColor = .red
                }
            } else {
                subLbl.textColor = .white
            }
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
