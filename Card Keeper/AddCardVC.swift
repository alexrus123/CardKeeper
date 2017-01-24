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

class MyImageCollection: UICollectionViewCell{
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var checkboxView: UIImageView!
}

extension UIViewController: UITextFieldDelegate{

    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.donePressed))
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.nextPressed))
        let previousButton = UIBarButtonItem(title: "Prev", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.previousPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func nextPressed(){
        //view.endEditing(true)
        AddCardVC().checkr()
    }
    func previousPressed(){
        view.endEditing(true)
    }
    func donePressed(){
        view.endEditing(true)
    }
}

class AddCardVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    var selectedCardType : Int = 0
    var currentTextField = UITextField()
    
    func checkr(){
        print("did")
        print(String(describing: currentTextField.tag))
        if currentTextField.tag == 1{
            self.cardNumberField.becomeFirstResponder()
        }
        if currentTextField.tag == 2{
            self.cardNameField.becomeFirstResponder()
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.currentTextField = textField
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolBar(textField: cardNameField)
        addToolBar(textField: cardNumberField)
        currentTextField.delegate = self
        /*
         
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        */
        //TODO: hide keyboard when tapped. The line below will break uicollectionviewcell tap
        //self.hideKeyboardWhenTappedAround()
    }
    /*
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    */
    @IBAction func SaveNow(_ sender: UIButton) {
        print("Saving: " + cardNumberField.text! as Any)
        CDhelper().saveToCoreData(cardProvider: String(ProviderList().allProvidersArray[selectedCardType]), cardName: String(cardNameField.text!), cardNumberVal: Int64(cardNumberField.text!)!)
    }
    
    let reuseIdentifier = "cell1" // also enter this string as the cell identifier in the storyboard
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Total Providers: " + String(ProviderList().allProvidersArray.count))
        return ProviderList().allProvidersArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyImageCollection
        cell.cellImageView?.image = UIImage(named: ProviderList().allProvidersArray[indexPath.item])
        //cell.backgroundColor = UIColor.red
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        selectedCardType = indexPath.item
        print("You selected: " + String(selectedCardType))
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyImageCollection
        cell.checkboxView.image = UIImage(named: "Checkbox")
        //cell?.backgroundColor = UIColor.magenta
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You deselected: " + String(indexPath.item))
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyImageCollection
        cell.checkboxView.image = nil
        //cell?.backgroundColor = UIColor.magenta
    }

}
