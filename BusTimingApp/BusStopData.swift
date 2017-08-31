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
    
    func updateTimings() {
        
        print("updating!")
        
        var json: JSON!
        
        do {
            
            guard let busURLString = busUrl, let stopId = stopNumber else { return }
            
            let urlString = busURLString + stopId
            guard let url = URL(string: urlString) else { return }
            let data = try Data(contentsOf: url)
            json = JSON(data: data)
            
        } catch _ {
            print("Couldn't update bus timings!")
        }
        
        let busesDictionary = json["services"].arrayValue
        for bus in busesDictionary {
            
            let busNo = bus["no"].stringValue
            
            if busNo == busNumber {
                
                let durationMs = bus["next"]["duration_ms"].doubleValue
                let subsequentMs = bus["subsequent"]["duration_ms"].doubleValue
                
                nextBusTiming = msToMinute(ms: durationMs)
                subsequentBusTiming = msToMinute(ms: subsequentMs)
                
                print("updated!")
            }
        }
    }
    
    func msToMinute(ms: Double) -> String {
        let minuteValue = Int(ms/60000)
        if minuteValue <= 0 {
            return "Arr"
        }
        return "\(minuteValue)"
    }
    
}

class BusStopData: NSObject {
    
    var busesData = [BusData]()
    
    private var busURL = "https://arrivelah.herokuapp.com/?id="
    
    func readJSON(BusID: String) {
        
        var json: JSON!
        
        do {
            let urlString = busURL + BusID
            guard let url = URL(string: urlString) else { return }
            let data = try Data(contentsOf: url)
            json = JSON(data: data)
        } catch _ {
            print("Couldn't download bus data")
        }
        
        let busesDictionary = json["services"].arrayValue
        for bus in busesDictionary {
            let busData = BusData()
            let durationMs = bus["next"]["duration_ms"].doubleValue
            let subsequentMs = bus["subsequent"]["duration_ms"].doubleValue
    
            busData.stopNumber = BusID
            busData.busUrl = busURL
            busData.busNumber = bus["no"].stringValue
            busData.nextBusTiming = msToMinute(ms: durationMs)
            busData.subsequentBusTiming = msToMinute(ms: subsequentMs)
            busesData.append(busData)
        }
        
    }
    
    func msToMinute(ms: Double) -> String {
        let minuteValue = Int(ms/60000)
        if minuteValue <= 0 {
            return "Arr"
        }
        return "\(minuteValue)"
    }
}
