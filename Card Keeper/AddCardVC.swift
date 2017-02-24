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

class AddCardVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate  {
    
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var saveCardBttn: UIButton!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var scanBttn: UIButton!

    let cellReuseIdentifier = "selectedProviderCell"
    
    var selectedCardType : Int = -1
    var currentTextField = UITextField()
    
    @IBAction func newAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let controller = BarcodeScannerController()
            controller.codeDelegate = self
            controller.errorDelegate = self
            controller.dismissalDelegate = self
            present(controller, animated: true, completion: nil)
        }
        else{
            noCameraHandler()
        }
    }
    /*
    @IBAction func openCameraView(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{noCameraHandler()}
    }
    */
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
    
    func openSelectProviderView(){
        //presentViewController(self.SelectCardVC, animated: true, completion: nil)
        self.performSegue(withIdentifier: "showPickNow", sender: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

        addToolBar(textField: cardNameField)
        addToolBar(textField: cardNumberField)
        currentTextField.delegate = self
        
        infoLabel.text = "Enter the customer number printed on your card and description. Tap scan to add number automatically"

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        cardNameField.setBottomBorder()
        cardNumberField.setBottomBorder()
        
        //Open camera after tapping on uiimageview. GestureRecognition:
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openSelectProviderView))
        providerImage.isUserInteractionEnabled = true
        providerImage.addGestureRecognizer(tapGestureRecognizer)
        if (selectedCardType > -1){
            providerImage.image = UIImage (named: ProviderList().allProvidersArray[selectedCardType])
        }
 
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
    
    public func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        cardNumberField.text = String(code)
        if (type == "org.gs1.EAN-13"){
            let gen = RSEAN13Generator.init()
            //gen.fillColor = UIColor.white
            //gen.strokeColor = UIColor.black
            cameraImageView.image = gen.generateCode(String(code), machineReadableCodeObjectType: "AVMetadataObjectTypeEAN13Code")
        }
        if (type == "org.gs1.EAN-18"){
            
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            controller.dismiss(animated: true, completion: nil)
            controller.resetWithError()
        }
        
    }
    public func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
    
    public func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
class Barcode {
    
    class func fromString(string : String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
        
    }
    
}
