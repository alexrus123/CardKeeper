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
    
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var cardNumberField: UITextField!
    
    @IBAction func testPrint(_ sender: UIButton) {
        
    }
    
    @IBAction func SaveNow(_ sender: UIButton) {
        print("Saving: " + cardNumberField.text! as Any)
        CDhelper.saveToCoreData(cardNumberVal: Int64(cardNumberField.text!)!)
    }
    
}
