//
//  BusStopData.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 30/8/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import SwiftyJSON

class BusData: NSObject {
    
    var stopNumber: String?
    var busUrl: String?
    var stopId: String?
    var busNumber: String?
    var nextBusTiming: String?
    var subsequentBusTiming: String?
    
    func updateTimings(completed: @escaping (_ downloadComplete: Bool) -> Void) {
        
        var json: JSON!
        
        DispatchQueue.global().async {
            
            do {
                
                guard let busURLString = self.busUrl, let stopId = self.stopNumber else { return }
                
                let urlString = busURLString + stopId + "&ServiceNo=" + self.busNumber!
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
                self.subsequentBusTiming = self.convertDateFormater(date: subsequentDate)
                    
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

class BusStopData: NSObject {
    
    
//    private var busURL = "https://arrivelah.herokuapp.com/?id="
    private var itachBusUrl = "http://api.itachi1706.com/api/busarrival.php?BusStopID="
    
    var busesData = [BusData]()
    
    var stopId: String? {
        didSet {
            if let stopID = stopId {
                readJSON(BusID: stopID)
            }
        }
    }
    
    func readJSON(BusID: String) {
        
        var json: JSON!
        
        do {
            let urlString = itachBusUrl + BusID
            guard let url = URL(string: urlString) else { return }
            let data = try Data(contentsOf: url)
            json = JSON(data: data)
        } catch _ {
            print("Couldn't download bus data")
        }
        
        let busesDictionary = json["Services"].arrayValue
        for bus in busesDictionary {
            let busData = BusData()
            let nextBusDate = bus["NextBus"]["EstimatedArrival"].stringValue
            let subsequentBusDate = bus["SubsequentBus"]["EstimatedArrival"].stringValue
            
            busData.stopNumber = BusID
            busData.busUrl = itachBusUrl
            busData.busNumber = bus["ServiceNo"].stringValue
            busData.nextBusTiming = convertDateFormater(date: nextBusDate)
            busData.subsequentBusTiming = convertDateFormater(date: subsequentBusDate)
            busesData.append(busData)
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
            
            print(timeDifference)
            return "\(timeDifference)"
        }
        
        return  ""
    }
}
