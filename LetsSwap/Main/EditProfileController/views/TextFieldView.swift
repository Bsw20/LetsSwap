//
//  TextFieldView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit


class TextFieldView: UIView {
    
    private var textField: UITextField
    
    init(placeholder: String) {
        textField = UITextField.getNormalTextField(placeholder: placeholder)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        setupTextfield()

    }
    
    private func setupTextfield() {
        addSubview(textField)
        textField.fillSuperview()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .detailsGrey()
        textField.clipsToBounds = true
    }
    
    public func resignTextField() {
        textField.resignFirstResponder()
    }
    
    
    public func getText() -> String?{
        return textField.text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
