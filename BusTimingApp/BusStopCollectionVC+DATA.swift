//
//  BusStopCollectionVCExt.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 6/9/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

extension BusStopCollectionViewController {
    
    func readJSON(busStopData: TempBusStopData) -> [TempBusData] {
        
        var busArray = [TempBusData]()
        var json: JSON!
        
        if let busStopID = busStopData.stopId {
            
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
                let busData = TempBusData()
                let nextBusDate = bus["NextBus"]["EstimatedArrival"].stringValue
                let subsequentBusDate = bus["SubsequentBus"]["EstimatedArrival"].stringValue
                
                busData.stopNumber = busStopID
                busData.busUrl = itachBusUrl
                busData.busNumber = bus["ServiceNo"].stringValue
                busData.nextBusTiming = convertDateFormater(date: nextBusDate)
                busData.subsequentBusTiming = convertDateFormater(date: subsequentBusDate)
                busArray.append(busData)
            }
        }
        
        return busArray
    }
    
//    func createGarbage(context: NSManagedObjectContext) {
//        let random = NSEntityDescription.insertNewObject(forEntityName: "BusData", into: context) as! BusData
//        random.busNumber = "12"
//        random.subsequentBusTiming = "12"
//        random.stopNumber = "92121"
//        random.subsequentBusTiming = "24"
//        
//        do {
//            try context.save()
//        } catch let err {
//            print(err)
//        }
//    }
    
    func setupStopData() {
        
        busArray = readJSON(busStopData: busStopData)
    }
    
    
    func saveData(busData: TempBusData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let newBusData = NSEntityDescription.insertNewObject(forEntityName: "BusData", into: context) as! BusData
            
            newBusData.busUrl = busData.busUrl
            newBusData.busNumber = busData.busNumber
            newBusData.nextBusTiming = busData.nextBusTiming
            newBusData.subsequentBusTiming = busData.subsequentBusTiming
            newBusData.stopNumber = busData.stopNumber
            
            do {
                try context.save()
                print("saved!")
                
            } catch let err {
                print(err)
            }
        }
    }
}
