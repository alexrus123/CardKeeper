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
        usernameField.text = "demo3"
        passwordField.text = "demo3"
        }
    
    @IBAction func loginNow(_ sender: Any) {
        let username = "cardsAdmin"
        let password = "demo"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // create the request
        let url = URL(string: "http://www.cards.qatsys.com/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self)
        /*
        let request = NSMutableURLRequest(url: NSURL(string: "http://cards.qatsys.com/wp-admin.php")! as URL)
        request.httpMethod = "POST"
        let postString = "log=cardsAdmin&pwd=demo"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
