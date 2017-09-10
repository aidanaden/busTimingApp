//
//  BookmarksCollectionVCExt.swift
//  BusTimingApp
//
//  Created by Aidan Aden on 8/9/17.
//  Copyright © 2017 Aidan Aden. All rights reserved.
//

import UIKit
import CoreData


extension BookmarksCollectionViewController {
    
    func loadData() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<BusData> = BusData.fetchRequest()
        
            do {
                busArray = try(context.fetch(fetchRequest)) as [BusData]
            } catch let err {
                print(err)
            }
        }
    }
    
    func clearData(busData: BusData) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            
            do {
                context.delete(busData)
                
                try context.save()
                
            } catch let err {
                print(err)
            }
        }
    }
    
    func reloadAll() {
        loadData()
        collectionView?.reloadData()
    }
}
