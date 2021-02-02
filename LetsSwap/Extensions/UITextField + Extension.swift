//
//  UITextField + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit

extension UITextField {
    static func getNormalTextField(placeholder: String) -> UITextField{
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.greyTextColor(), NSAttributedString.Key.font: UIFont.circeRegular(with: 17)])
        textField.backgroundColor = .detailsGrey()
        textField.clipsToBounds = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: textField.frame.height))
        textField.leftViewMode = .always

        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: textField.frame.height))
        textField.rightViewMode = .always
        
        textField.textColor = .mainTextColor()
        textField.font = UIFont.circeRegular(with: 17)
        
        return textField
    }
}
