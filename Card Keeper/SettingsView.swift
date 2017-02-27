//
//  SettingsView.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 2/12/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit
import waterwheel

class Settings : UIViewController{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBttn: UIButton!
    let ww = waterwheelLoginViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ww.usernameField.text = "demo"
        ww.passwordField.text = "demo"
    
    // Lets add our function that will be run when the request is completed.
    ww.loginRequestCompleted = { (success, error) in
    if (success) {
    // Do something related to a successfull login
    print("successfull login")
    self.dismiss(animated: true, completion: nil)
    } else {
    print (error!)
    }
    }
    
    // Define our logout action
    ww.logoutRequestCompleted = { (success, error) in
    if (success) {
    print("successfull logout")
    // Do something related to a successfull logout
    self.dismiss(animated: true, completion: nil)
    } else {
    print (error!)
    }
    }
    
    // Define our cancel button action
    ww.cancelButtonHit = {
    self.dismiss(animated: true, completion: nil)
    }
    
        /*
    // Do any additional setup after loading the view, typically from a nib.
    loginBttn.isTouchInside = {
    // Lets Present our Login View Controller since this closure is for the loginButton press
    
    }
    
    loginBttn.touch = { (success, error) in
    print("logged out")
    }
    */
    }
    
    @IBAction func loginNow(_ sender: Any) {
        self.present(ww, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
