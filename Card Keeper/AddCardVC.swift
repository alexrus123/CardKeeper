//
//  AddCardVC.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/17/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddCardVC: UIViewController {
    @IBOutlet weak var testBttn: UIButton!
    
    let managedObjectContext = (UIApplication.shared.delegate
        as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var cardNumberField: UITextField!
    
    @IBAction func testPrint(_ sender: UIButton) {
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
    
    @IBAction func SaveNow(_ sender: UIButton) {
        print("Saving: " + cardNumberField.text! as Any);
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Cards",
                                       in: managedObjectContext)
        
        let cardDetails = Cards(entity: entityDescription!,
                               insertInto: managedObjectContext)
        
        cardDetails.cardNumber = Int64(cardNumberField.text!)!
        
        
        do {
            try managedObjectContext.save()
            //status.text = "Contact Saved"
            
        } catch let error {
            //status.text = error.localizedDescription
            print(error.localizedDescription)
        }

    }
    
}
