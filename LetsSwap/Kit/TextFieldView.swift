//
//  TextFieldView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit

protocol TextFieldViewDelegate: AnyObject {
    func textDidChange(textFieldView: TextFieldView, newText: String)
}

class TextFieldView: UIView {
    
    private var textField: UITextField
    
    weak var delegate: TextFieldViewDelegate?
    
    
    init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        textField = UITextField.getNormalTextField(placeholder: placeholder)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        addGestureRecognizer(recognizer)
        
        setupTextfield()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        textField.keyboardType = keyboardType

    }
    
    //MARK: - funcs
    private func setupTextfield() {
        addSubview(textField)
        textField.fillSuperview()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .detailsGrey()
        textField.clipsToBounds = true
    }
    
    public func isEmpty() -> Bool{
        return textField.text?.isEmpty ?? true
    }
    
    public func applyPatternOnNumbers(apply: Bool = true) {
        
    }
    
    
    public func getText() -> String{
        return textField.text ?? " "
    }
    
    public func setText(newText: String) {
        textField.text = newText
    }
    //MARK: - Objc funcs
    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.textDidChange(textFieldView: self, newText: textField.text ?? "")
    }
    
    @objc public func resignTextField() {
        textField.resignFirstResponder()
    }
    

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
