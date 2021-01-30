//
//  OTPTextField.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 30.01.2021.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
