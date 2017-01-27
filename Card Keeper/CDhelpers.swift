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
    var allCards = [Cards]()
    
    func fetchCoreData()->[Cards]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            allCards = results as! [Cards]
            
            for singleCard in allCards {
                print("Card Provider: " + singleCard.cardProvider!)
                print("Card Name: " + singleCard.cardName!)
                print("Card Number: " + String(singleCard.cardNumber))
                print("Card Status: " + String(singleCard.cardStatus))
            }
            print("Total cards: " + String(allCards.count))
        } catch let error as NSError {
            //print("Could not fetch \(error)”),
            print(error.code)
        }
        return allCards
    }
    
    func saveToCoreData(cardProvider: String, cardName: String, cardNumberVal: Int64){
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Cards",
                                       in: managedObjectContext)
        
        let cardDetails = Cards(entity: entityDescription!,
                                insertInto: managedObjectContext)
        
        cardDetails.cardProvider = cardProvider
        cardDetails.cardNumber = cardNumberVal
        cardDetails.cardName = cardName
        cardDetails.cardStatus = true

        //cardDetails.cardNumber = Int64(cardNumberField.text!)!
        
        
        do {
            try managedObjectContext.save()
            //status.text = "Contact Saved"
            
        } catch let error {
            //status.text = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
    func cardSoftDeletion(array: [Cards], index: IndexPath){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 1
        //array[index].cardStatus = false
        // 2
        appDelegate.saveContext()
    }
    
}
