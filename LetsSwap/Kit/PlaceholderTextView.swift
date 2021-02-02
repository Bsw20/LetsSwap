//
//  PlaceholderTextView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 02.02.2021.
//

import Foundation
import UIKit

protocol PlaceholderTextViewDelegate: NSObjectProtocol {
    func textDidChange(view: PlaceholderTextView, newText: String)
}

class PlaceholderTextView: UITextView {
    
    //MARK: - Variables
    private var placeholder: String
    private var placeholderColor: UIColor
    private var normalTextColor: UIColor
    private var currentText: String = ""
    
    weak var customDelegate: PlaceholderTextViewDelegate?
    
    init(placeholder: String = "", placeholderColor: UIColor = .greyTextColor(), textColor: UIColor = .mainTextColor(), font: UIFont = UIFont.circeRegular(with: 17)) {
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.normalTextColor = textColor
        super.init(frame: .zero, textContainer: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = placeholderColor
        self.text = placeholder
        self.font = font
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        layer.borderWidth = 1
        textContainerInset = UIEdgeInsets(top: 23, left: 24, bottom: 24, right: 23)

        delegate = self
        
        
    }
    
    override func layoutSubviews() {
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - funcs
    public var isEmpty: Bool  {
        return currentText == ""
    }
    
    public func getText() -> String {
        return currentText
    }
}


//MARK: - UITextViewDelegate
extension PlaceholderTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            currentText = ""
            textView.text = ""
            textView.textColor = normalTextColor

        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            print("EMPYYY")
            textColor = placeholderColor
            currentText = ""
            text = placeholder
        }
    }
    #warning("TODO")
            
    func textViewDidChange(_ textView: UITextView) {
        currentText = textView.text
        customDelegate?.textDidChange(view: self, newText: currentText)
    }
}

//extension FullOrderViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == CommentConstants.textViewTextColor {
//            textView.text = nil
//                textView.textColor = UIColor.black
//        }
//        print("did begin")
//        }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            yellowButton.isEnabled = false
//            textView.textColor = CommentConstants.textViewTextColor
//            print("is empty")
//            if textView == titleTextView {
//                textView.text = "Добавь название"
//            } else if textView == descriptionTextView {
//                textView.text = "Добавь описание"
//            } else if textView == counterOfferTextView {
//                textView.text = "Напиши, что хочешь взамен"
//            }
//        } else {
//            yellowButton.isEnabled = true
//        }
//    }
//    #warning("TODO")
//    func textViewDidChange(_ textView: UITextView) {
//        validateConfirmation()
//        print("did change")
//    }
//
