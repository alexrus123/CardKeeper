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
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

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
