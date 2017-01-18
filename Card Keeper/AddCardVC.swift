//
//  AddCardVC.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/17/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

class AddCardVC: UIViewController {
    
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var cardNumberField: UITextField!
    
    @IBAction func SaveNow(_ sender: UIButton) {
        print("Tapped!!");
        print(cardNumberField.text as Any);
    }
    
}
