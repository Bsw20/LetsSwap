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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        addGestureRecognizer(recognizer)
        
        setupTextfield()

    }
    
//    override func didMoveToSuperview() {
//        superview?.backgroundColor = .blue
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
//        superview?.addGestureRecognizer(recognizer)
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textField.resignFirstResponder()
//    }
    
    private func setupTextfield() {
        addSubview(textField)
        textField.fillSuperview()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .detailsGrey()
        textField.clipsToBounds = true
    }
    
    @objc public func resignTextField() {
        textField.resignFirstResponder()
//        self.endEditing(true)
//        print("worked")
    }
    
    
    public func getText() -> String?{
        return textField.text
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
