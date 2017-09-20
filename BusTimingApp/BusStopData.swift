////
////  BusStopData.swift
////  BusTimingApp
////
////  Created by Aidan Aden on 30/8/17.
////  Copyright © 2017 Aidan Aden. All rights reserved.
////
//
import UIKit
import SwiftyJSON

class TempBusData: NSObject {
    
    var _stopNumber: String?
    var _busUrl: String?
    var _busNumber: String?
    var _nextBusTiming: String?
    var _subsequentBusTiming: String?
    
    init(stopNumber: String, busUrl: String, busNumber: String, nextBus: String, subBus: String) {
        _stopNumber = stopNumber
        _busUrl = busUrl
        _busNumber = busNumber
        _nextBusTiming = nextBus
        _subsequentBusTiming = subBus
    }
    
    func updateTimings(completed: @escaping (_ downloadComplete: Bool) -> Void) {
        
        var json: JSON!
        
        DispatchQueue.global().async {
            
            do {
                
                guard let busURLString = self._busUrl, let stopId = self._stopNumber else { return }
                
                let urlString = busURLString + stopId + "&ServiceNo=" + self._busNumber!
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
                    
                self._nextBusTiming = self.convertDateFormater(date: durationDate)
                self._subsequentBusTiming = self.convertDateFormater(date: subsequentDate)
                    
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
}

class TempBusStopData: NSObject {
    
    
//    private var busURL = "https://arrivelah.herokuapp.com/?id="
    private var itachBusUrl = "http://api.itachi1706.com/api/busarrival.php?BusStopID="
    
//    var busesData = [TempBusData]()
    
    var stopId: String?
    
    func readJSON() -> [TempBusData] {
        
        var busArray = [TempBusData]()
        var json: JSON!
        
        if let busStopID = self.stopId {
            
            do {
                let urlString = itachBusUrl + busStopID
                if let url = URL(string: urlString) {
                    let data = try Data(contentsOf: url)
                    json = JSON(data: data)
                }
                
                
            } catch _ {
                print("Couldn't download bus data")
            }
            
            let busesDictionary = json["Services"].arrayValue
            for bus in busesDictionary {
                
                let nextBusDate = bus["NextBus"]["EstimatedArrival"].stringValue
                let subsequentBusDate = bus["SubsequentBus"]["EstimatedArrival"].stringValue
                
                let stopNumber = busStopID
                let busUrl = itachBusUrl
                let busNumber = bus["ServiceNo"].stringValue
                let nextBusTiming = convertDateFormater(date: nextBusDate)
                let subsequentBusTiming = convertDateFormater(date: subsequentBusDate)
                
                let busData = TempBusData(stopNumber: stopNumber, busUrl: busUrl, busNumber: busNumber, nextBus: nextBusTiming, subBus: subsequentBusTiming)
                busArray.append(busData)
            }
        }
        
        return busArray
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
            
            print(timeDifference)
            return "\(timeDifference)"
        }
        
        return  ""
    }
}
