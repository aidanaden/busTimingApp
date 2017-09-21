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
    
    func setupStopData(id: String) {
        
        self.busStopData.stopId = id
        busArray = busStopData.readJSON()

        tableView.reloadData()
    }
    
    
    func saveData(tempBusData: TempBusData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let newBusData = NSEntityDescription.insertNewObject(forEntityName: "BusData", into: context) as! BusData
            
            newBusData.busUrl = tempBusData._busUrl
            newBusData.busNumber = tempBusData._busNumber
            newBusData.nextBusTiming = tempBusData._nextBusTiming
            newBusData.subsequentBusTiming = tempBusData._nextBusTiming
            newBusData.stopNumber = tempBusData._stopNumber
            
            do {
                try context.save()
                print("saved!")
                loadData()
            } catch let err {
                print(err)
            }
        }
    }
    
    func loadData() {
        
        storedBusArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<BusData>(entityName: "BusData")
            
            do {
                buses = try context.fetch(fetchRequest) as [BusData]
        
                for bus in buses {
                    if let stopNo = bus.stopNumber, let url = bus.busUrl, let busNo = bus.busNumber, let next = bus.nextBusTiming, let sub = bus.subsequentBusTiming {
                        
                        let tempBus = TempBusData(stopNumber: stopNo, busUrl: url, busNumber: busNo, nextBus: next, subBus: sub)
                        storedBusArray.append(tempBus)
                    }
                }
                
                busArray = storedBusArray
                tableView.reloadData()
            } catch let err {
                print(err)
            }
        }
    }
    
    func deleteData(index: Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<BusData>(entityName: "BusData")
            
            do {
                buses = try context.fetch(fetchRequest) as [BusData]
                let removingBusData = buses[index]
                context.delete(removingBusData)
                try context.save()
                print("DELETED")
                busArray.remove(at: index)
                
                let indexPath = IndexPath(row: index, section: 0)
                tableView.deleteRows(at: [indexPath], with: .left)
                
            } catch let err {
                print(err)
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
