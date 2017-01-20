//
//  CDhelpers.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/17/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CDhelper {
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchCoreData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let  Locations = results as! [Cards]
            
            for location in Locations {
                print(String(location.cardNumber))
            }
        } catch let error as NSError {
            //print("Could not fetch \(error)”),
            print(error.code)
        }
    }
    
    func saveToCoreData(cardNumberVal: Int64){
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Cards",
                                       in: managedObjectContext)
        
        let cardDetails = Cards(entity: entityDescription!,
                                insertInto: managedObjectContext)
        
        cardDetails.cardNumber = cardNumberVal

        //cardDetails.cardNumber = Int64(cardNumberField.text!)!
        
        
        do {
            try managedObjectContext.save()
            //status.text = "Contact Saved"
            
        } catch let error {
            //status.text = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
}
