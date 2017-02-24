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
    @IBOutlet weak var selectedProviderImage: UIImageView!
    @IBOutlet weak var selectedCardNumberField: UITextField!
    @IBOutlet weak var selectedCardBackImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var indexTapped : Int = 0
    var infoReceived : Cards?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.selectedProviderImage.image = UIImage (named: (infoReceived?.cardProvider)!)
        self.selectedCardDescription.text = infoReceived?.cardName
        
        self.selectedCardDescription.setBottomBorder()
        addToolBar(textField: selectedCardDescription)
        self.selectedCardNumberField.setBottomBorder()
        addToolBar(textField: selectedCardNumberField)
        
        self.selectedCardNumberField.text = String(describing: infoReceived!.cardNumber)
        self.selectedCardBackImage.image = UIImage(data: infoReceived?.cardBackImage as! Data)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /*
    func rotateImage(image:UIImage)->UIImage
    {
        var rotatedImage = UIImage();
        switch image.imageOrientation
        {
        case UIImageOrientation.right:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.down);
            
        case UIImageOrientation.down:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.left);
            
        case UIImageOrientation.left:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.up);
            
        default:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.right);
        }
        return rotatedImage;
    }
    */
    
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
        if (self.selectedCardNumberField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Error", message: "Card number is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            CDhelper().updateCoreData(cardId: infoReceived!, cardName: selectedCardDescription.text!,cardNumber: Int64(selectedCardNumberField.text!)!, cardImage: selectedCardBackImage.image!)
            let alert = UIAlertController(title: "Congratulations", message: "Your changes are saved!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            self.performSegue(withIdentifier: "MainVC", sender: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButtonEditVC(_ sender: UIButton) {
        print("delete")
        let alert = UIAlertController(title: "Confirm", message: "You about to delete your card. Tap Ok to delete your card", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
            CDhelper().cardSoftDeletion(index: self.indexTapped)
            self.performSegue(withIdentifier: "MainVC", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
