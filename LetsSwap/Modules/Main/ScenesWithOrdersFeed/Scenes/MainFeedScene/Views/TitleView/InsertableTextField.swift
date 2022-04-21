//
//  InsertableTextField.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//


import Foundation
import UIKit
protocol InsertableTextFieldDelegate: NSObjectProtocol {
    func didChange(newText: String)
}


class InsertableTextField: UITextField {
    
    weak var customDelegate: InsertableTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        attributedPlaceholder = NSAttributedString(string: "Найди на что хочешь махнуться",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.greyTextColor()])
        textColor = .mainTextColor()
        font = UIFont.systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        layer.cornerRadius = 20
        layer.masksToBounds = true
        InsertableTextField.appearance().tintColor = .black
        
        let image = UIImage(named: "search")
        leftView = UIImageView(image: image)
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textDidChange() {
        if let text = text {
            customDelegate?.didChange(newText: text)
        }
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
}



