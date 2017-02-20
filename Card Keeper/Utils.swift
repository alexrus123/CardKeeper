//
//  Utils.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/19/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class Utils{
    //TODO move all alerts HERE
    
    func showAlert(controllerTitle: String, controllerMessage: String, secondButtonTitle: String, secondButtonAction: Any){
        
    }
}
