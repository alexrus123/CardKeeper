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

extension UITextField{
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
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
        view.endEditing(true)
    }
    func previousPressed(){
        view.endEditing(true)
    }
    func donePressed(){
        view.endEditing(true)
    }
}

class AddCardVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraBttn: UIBarButtonItem!

    
    var selectedCardType : Int = 0
    var currentTextField = UITextField()
    
    @IBAction func openCameraView(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{noCameraHandler()}
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        cameraImageView.contentMode = .scaleAspectFit //3
        cameraImageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCameraHandler(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cardNameField.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingChanged)
        //cardNumberField.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingChanged)
        //saveCardBttn.isEnabled = false
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

        addToolBar(textField: cardNameField)
        addToolBar(textField: cardNumberField)
        currentTextField.delegate = self
        
        infoLabel.text = "Enter the customer number printed on your card and description"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        cardNameField.setBottomBorder()
        cardNumberField.setBottomBorder()
        
        //Open camera after tapping on uiimageview. GestureRecognition:
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCameraView))
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //TODO: hide keyboard when tapped. The line below will break uicollectionviewcell tap
        //self.hideKeyboardWhenTappedAround()
    }
    
    func uiTextStyles(){
        cardNameField.layer.borderColor = UIColor.gray.cgColor
        cardNameField.layer.borderWidth = 1.0
        cardNameField.layer.cornerRadius = 5
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
    
    @IBAction func SaveNow(_ sender: UIButton) {
        if (self.cardNumberField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Error", message: "Card number is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.infoLabel.textColor = UIColor.red
        }
        else{
            CDhelper().saveToCoreData(cardProvider: String(ProviderList().allProvidersArray[selectedCardType]), cardName: String(cardNameField.text!), cardNumberVal: Int64(cardNumberField.text!)!, cardBackImage: cameraImageView.image!)
            let alert = UIAlertController(title: "Congratulations", message: "Your card is saved!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
                self.performSegue(withIdentifier: "to_mainView", sender: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    let reuseIdentifier = "cell1" // also enter this string as the cell identifier in the storyboard
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("Total Providers: " + String(ProviderList().allProvidersArray.count))
        return ProviderList().allProvidersArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyImageCollection
        cell.cellImageView?.image = UIImage(named: ProviderList().allProvidersArray[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected: " + String(indexPath.item))
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyImageCollection
        cell.checkboxView.image = UIImage(named: "Checkbox")
        selectedCardType = indexPath.row
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print("You deselected: " + String(indexPath.item))
        
        let cell = collectionView.cellForItem(at: indexPath) as? MyImageCollection
            cell?.checkboxView.image = nil
        /*
        if let cell = collectionView.cellForItem(at: indexPath) as? MyImageCollection {
            cell.checkboxView.image = nil
        }
        */
    }

}
