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
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.backgroundColor = .clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
        subLbl.textColor = .white
        subLbl.textAlignment = .center
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
    
    let firstBusTypeBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondBusTypeBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    var busURL: String?
    var busNumber: String?
    var stopNumber: String?
    var nextBusTiming: String?
    var subBusTiming: String?
    var nextStanding: String?
    var subStanding: String?
    var nextBusType: String?
    var subBusType: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(busNumberLbl)
        addSubview(busIdLbl)
        addSubview(nextBusButton)
        addSubview(subsequentLbl)
        addSubview(firstBusTypeBar)
        addSubview(secondBusTypeBar)
        addSubview(busActivityIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        busNumberLbl.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/2 - 65/2 + 2).isActive = true
        busNumberLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        busNumberLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 65).isActive = true
        busNumberLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true
        
        busIdLbl.leadingAnchor.constraint(equalTo: busNumberLbl.leadingAnchor, constant: 0).isActive = true
        busIdLbl.topAnchor.constraint(equalTo: busNumberLbl.bottomAnchor, constant: 0).isActive = true
        busIdLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
        busIdLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 58).isActive = true
        
        _ = nextBusButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: frame.height/2 - 65/2, leftConstant: 0, bottomConstant: 0, rightConstant: -18, widthConstant: 100, heightConstant: 65)
        
        _ = subsequentLbl.anchor(nil, left: nil, bottom: nextBusButton.bottomAnchor, right: nextBusButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 22, widthConstant: 20, heightConstant: 20)

        firstBusTypeBar.topAnchor.constraint(equalTo: nextBusButton.topAnchor, constant: 12).isActive = true
        firstBusTypeBar.leftAnchor.constraint(equalTo: nextBusButton.leftAnchor, constant: 28).isActive = true
        firstBusTypeBar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        firstBusTypeBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        firstBusTypeBar.layer.cornerRadius = firstBusTypeBar.frame.height/4
        
        secondBusTypeBar.bottomAnchor.constraint(equalTo: subsequentLbl.topAnchor, constant: -3).isActive = true
        secondBusTypeBar.leadingAnchor.constraint(equalTo: subsequentLbl.leadingAnchor, constant: 5).isActive = true
        secondBusTypeBar.widthAnchor.constraint(equalToConstant: 10).isActive = true
        secondBusTypeBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        secondBusTypeBar.layer.cornerRadius = secondBusTypeBar.frame.height/4


        busActivityIndicator.centerXAnchor.constraint(equalTo: nextBusButton.centerXAnchor, constant: -13.5).isActive = true
        busActivityIndicator.centerYAnchor.constraint(equalTo: nextBusButton.centerYAnchor).isActive = true
        
    }
    
    func populateCell(busNumber: String, nextBus: String, subBus: String, busURL: String, stopNum: String, bookMarked: Bool, nextStanding: String, subStanding: String, nextBusType: String, subBusType: String) {
        
        self.busNumber = busNumber
        self.nextBusTiming = nextBus
        self.subBusTiming = subBus
        self.busURL = busURL
        self.stopNumber = stopNum
        self.nextStanding = nextStanding
        self.subStanding = subStanding
        self.nextBusType = nextBusType
        self.subBusType = subBusType
        
        busNumberLbl.text = busNumber
        busIdLbl.text = stopNum
        checkStandingStatusButton(busTiming: nextBus, standingStatus: nextStanding, nextBtn: nextBusButton)
        checkStandingStatusLabel(busTiming: subBus, standingStatus: subStanding, subLbl: subsequentLbl)
        nextBusButton.setTitle("\(nextBus)", for: .normal)
        subsequentLbl.text = subBus
        setFirstLbl(firstBusType: nextBusType)
        setSecondLbl(secondBusType: subBusType)
        
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
                        
                        if let nextBusType = self.nextBusType {
                            self.setFirstLbl(firstBusType: nextBusType)
                        }
                        
                        if let subBusType = self.subBusType {
                            self.setSecondLbl(secondBusType: subBusType)
                        }
                        
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
                        let nextBusDate = nextBus["EstimatedArrival"]!
                        let subsequentBusDate = subsequentBus["EstimatedArrival"]!
                        let nextBusType = nextBus["Type"]
                        let subBusType = subsequentBus["Type"]
                        
                    
                        self.nextBusTiming = convertDateFormater(date: nextBusDate)
                        self.subBusTiming = convertDateFormater(date: subsequentBusDate)
                        self.nextStanding = nextBus["Load"]
                        self.subStanding = subsequentBus["Load"]
                        self.nextBusType = nextBusType
                        self.subBusType = subBusType
                        
                        completed(true)
                    }
                }
            })
            
        }
    }
    
    
    func checkStandingStatusButton(busTiming: String, standingStatus: String, nextBtn: UIButton) {

        if busTiming != "Arr" {
            if let intBusTiming = Int(busTiming) {
                if intBusTiming <= 3 {
                    if standingStatus == "SEA" {
                        nextBtn.setTitleColor(.green, for: .normal)
                    } else if standingStatus == "SDA" {
                        nextBtn.setTitleColor(standingColor, for: .normal)
                    } else if standingStatus == "LSD" {
                        nextBtn.setTitleColor(.red, for: .normal)
                    }
                } else {
                    nextBtn.setTitleColor(.white, for: .normal)
                }
            }
        } else {
            if standingStatus == "SEA" {
                nextBtn.setTitleColor(.green, for: .normal)
            } else if standingStatus == "SDA" {
                nextBtn.setTitleColor(standingColor, for: .normal)
            } else if standingStatus == "LSD" {
                nextBtn.setTitleColor(.red, for: .normal)
            }
        }
    }
    
    func checkStandingStatusLabel(busTiming: String, standingStatus: String, subLbl: UILabel) {
        
        if busTiming != "Arr" {
            if let intBusTiming = Int(busTiming) {
                if intBusTiming <= 3 {
                    if standingStatus == "SEA" {
                        subLbl.textColor = .green
                    } else if standingStatus == "SDA" {
                        subLbl.textColor = standingColor
                    } else if standingStatus == "LSD" {
                        subLbl.textColor = .red
                    }
                } else {
                    subLbl.textColor = .white
                }
            }
        } else {
            if standingStatus == "SEA" {
                subLbl.textColor = .green
            } else if standingStatus == "SDA" {
                subLbl.textColor = standingColor
            } else if standingStatus == "LSD" {
                subLbl.textColor = .red
            }
        }
    }
    
    func setFirstLbl(firstBusType: String) {
        if firstBusType == "SD" {
            firstBusTypeBar.alpha = 0
        } else if firstBusType == "DD" {
            firstBusTypeBar.alpha = 0.9
        }
    }
    
    func setSecondLbl(secondBusType: String) {
        if subsequentLbl.text != "" {
            if secondBusType == "SD" {
                secondBusTypeBar.alpha = 0
            } else if secondBusType == "DD" {
                secondBusTypeBar.alpha = 0.9
            }
        } else {
            secondBusTypeBar.alpha = 0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
