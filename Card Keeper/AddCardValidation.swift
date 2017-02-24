//
//  AddCardValidation.swift
//  Card Keeper
//
//  Created by Aliaksei Lyskovich on 1/25/17.
//  Copyright © 2017 Aliaksei Lyskovich. All rights reserved.
//

import Foundation
import UIKit

class AddCardValidation{
    
    func validateCardDescription(input: String)->Bool{
        if(input.isEmpty || input==""){
            return false
        }else{
            return true}
    }
    
    func validateCardNumber(input: String)->Bool{
        if(input.isEmpty){
            return false
        }
        return true
    }
}
