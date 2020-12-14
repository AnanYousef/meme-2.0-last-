//
//  TextClearDelegate.swift
//  MEME 1.0
//
//  Created by Anan Yousef on 09/12/2020.
//

import Foundation
import UIKit

class TextClearDelegate: NSObject ,UITextFieldDelegate  {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    }
    
    

