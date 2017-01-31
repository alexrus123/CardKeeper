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
    var receivedData = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
