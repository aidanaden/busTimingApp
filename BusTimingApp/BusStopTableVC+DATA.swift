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
        busStopData.readJSON(completionHandler: { (busesArray) in
            self.busArray = busesArray
            self.tableView.reloadData()
        })
    }
    
    @objc func updateBusArrayTimings() {
        
        let max = busArray.count
        for num in 0..<max {
            
            let index = IndexPath(row: num, section: 0)
            if let cell = tableView.cellForRow(at: index) as? BusCell {
                cell.updateBusTimings()
            }
        }
    }
    
    func updateBookmarkedValues(buses: [BusData]) {
        
        let group = DispatchGroup()
        self.storedBusArray.removeAll()
        
        for bus in buses {
            let tempBus = TempBusData(busData: bus)
            group.enter()
            tempBus.updateTimings(completed: { (completed) in
                if completed {
                    self.storedBusArray.append(tempBus)
                    group.leave()
                } else {
                    self.storedBusArray.append(tempBus)
                    group.leave()
                }
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.storedBusArray.sort(by: { (a, b) -> Bool in
                
                let firstBusNumString = a._busNumber!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890").inverted)
                let secondBusNumString = b._busNumber!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890").inverted)
                
                let firstNum = Int(firstBusNumString)
                let secondNum = Int(secondBusNumString)
                let firstStop = Int(a._stopNumber!)
                let secondStop = Int(b._stopNumber!)
                
                if firstStop != secondStop {
                    return firstStop! < secondStop!
                } else if firstNum != secondNum {
                    return firstNum! < secondNum!
                }
    
                return false
            })
            
            self.busArray = self.storedBusArray
            self.tableView.reloadData()
            print("reloaded table")
        }
    }
    
    func saveData(tempBusData: TempBusData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let newBusData = NSEntityDescription.insertNewObject(forEntityName: "BusData", into: context) as! BusData
            
            newBusData.busUrl = tempBusData._busUrl
            newBusData.busNumber = tempBusData._busNumber
            newBusData.stopNumber = tempBusData._stopNumber
            newBusData.bookMarked = tempBusData._bookmarked!
            
            do {
                try context.save()
                print("saved!")
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func loadData() {
    
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<BusData>(entityName: "BusData")
            
            do {
                buses = try context.fetch(fetchRequest) as [BusData]
                updateBookmarkedValues(buses: buses)
                
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
}
