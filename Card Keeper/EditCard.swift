//
//  EditCard.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/29/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

class EditCard: UIViewController{
    @IBOutlet weak var saveChangesBttn: UIButton!
    @IBOutlet weak var selectedCardDescription: UITextField!
    @IBOutlet weak var selectedCardNumberField: UITextField!
    @IBOutlet weak var selectedCardBackImage: UIImageView!
    var infoReceived : Cards?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(String(describing: infoReceived?.objectID))
        self.selectedCardDescription.text = infoReceived?.cardName
        self.selectedCardNumberField.text = String(describing: infoReceived?.cardNumber)
        self.selectedCardBackImage.image = UIImage(data: infoReceived?.cardBackImage as! Data)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }
    
    @IBAction func UpdateNow(_ sender: UIButton) {
        CDhelper().updateCoreData(cardId: infoReceived!, cardName: selectedCardDescription.text!,cardNumber: Int64(selectedCardNumberField.text!)!, cardImage: selectedCardBackImage.image!)
        let alert = UIAlertController(title: "Congratulations", message: "Your card is saved!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            self.performSegue(withIdentifier: "MainVC", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
