////
////  BusStopData.swift
////  BusTimingApp
////
////  Created by Aidan Aden on 30/8/17.
////  Copyright © 2017 Aidan Aden. All rights reserved.
////

import UIKit
import SwiftyJSON
import Alamofire

class TempBusData: NSObject {
    
    var _stopNumber: String?
    var _busUrl: String?
    var _busNumber: String?
    var _nextBusTiming: String?
    var _subsequentBusTiming: String?
    var _bookmarked: Bool?
    var _nextStanding: String?
    var _subStanding: String?
    var _nextBusType: String?
    var _subBusType: String?
    
    init(stopNumber: String, busUrl: String, busNumber: String) {
        
        _stopNumber = stopNumber
        _busUrl = busUrl
        _busNumber = busNumber
        _bookmarked = false
    }
    
    convenience init(stopNumber: String, busUrl: String, busNumber: String, nextBus: String, subBus: String, nextBusType: String, subBusType: String, nextStanding: String, subStanding: String) {
        self.init(stopNumber: stopNumber, busUrl: busUrl, busNumber: busNumber)
        
        _nextBusTiming = nextBus
        _subsequentBusTiming = subBus
        _nextBusType = nextBusType
        _subBusType = subBusType
        _nextStanding = nextStanding
        _subStanding = subStanding
    }
    
    convenience init(busData: BusData) {
        self.init(stopNumber: busData.stopNumber!, busUrl: busData.busUrl!, busNumber: busData.busNumber!)
        _bookmarked = busData.bookMarked
    }
   
    
    @objc func updateTimings(completed: @escaping (_ downloadComplete: Bool) -> Void) {
        
        DispatchQueue.global().async {
        
            guard let stopNumber = self._stopNumber, let busNumber = self._busNumber else {
                print("no bus or stop number")
                return
            }
            
            let urlString = dataUrl + stopNumber + busParameter + busNumber
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
                        
                        self._nextBusTiming = convertDateFormater(date: nextBusDate)
                        self._subsequentBusTiming = convertDateFormater(date: subsequentBusDate)
                        self._nextStanding = nextBus["Load"]
                        self._subStanding = subsequentBus["Load"]
                        self._nextBusType = nextBusType
                        self._subBusType = subBusType
                        
                        completed(true)
                    }
                }
            })
        }
    }
}

class TempBusStopData: NSObject {
    
//    USED PRIMARILY FOR LOADING BUS STOP DATA FROM STOP ID
    
    var stopId: String?
    
    func readJSON(completionHandler: @escaping (_ busArray: [TempBusData]) -> Void) {

        var busArray = [TempBusData]()

        if let busStopID = self.stopId {
    
            let urlString = dataUrl + busStopID
            let parameters = ["AccountKey" : apiKey,
                              "accept" : "application/json"]
            if let url = URL(string: urlString) {
                Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: parameters ).responseJSON(completionHandler: { (response) in
                    if let data = response.result.value as? [String: Any] {
                        
                        let busesDictionary = data["Services"] as! [[String: Any]]
                        
                        for bus in busesDictionary {
                            
                            let nextBus = bus["NextBus"] as! [String: String]
                            let subsequentBus = bus["NextBus2"] as! [String: String]
                            let nextBusDate = nextBus["EstimatedArrival"]!
                            let subsequentBusDate = subsequentBus["EstimatedArrival"]!
                            let stopNumber = busStopID
                            let busUrl = dataUrl
                            let busNumber = bus["ServiceNo"] as! String
                            let nextBusTiming = convertDateFormater(date: nextBusDate)
                            let subsequentBusTiming = convertDateFormater(date: subsequentBusDate)
                            
                            
                            let nextStanding = nextBus["Load"]!
                            let subStanding = subsequentBus["Load"]!
                            let nextBusType = nextBus["Type"]!
                            let subBusType = subsequentBus["Type"]!
                            
                            let busData = TempBusData(stopNumber: stopNumber, busUrl: busUrl, busNumber: busNumber, nextBus: nextBusTiming, subBus: subsequentBusTiming, nextBusType: nextBusType
                                , subBusType: subBusType, nextStanding: nextStanding, subStanding: subStanding)
                            
                            busArray.append(busData)
                            print(busArray.count)
                        }
                        
                        busArray.sort(by: { (a, b) -> Bool in
                            
                            let firstBusNumString = a._busNumber!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890").inverted)
                            let secondBusNumString = b._busNumber!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890").inverted)
                            
                            if let firstBusNum = Int(firstBusNumString), let secondBusNum = Int(secondBusNumString) {
                                let asc = firstBusNum < secondBusNum
                                return asc
                            }
                            
                            return false
                        })
                        
                        completionHandler(busArray)
                    }
                })
                
            }
        }
    }
}
