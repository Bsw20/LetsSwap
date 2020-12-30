//
//  UITextView + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//

import Foundation
import UIKit

extension UITextView {
    static func getNormalTextView()  -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.circeRegular(with: 17)
        textView.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 23, left: 24, bottom: 24, right: 23)
        textView.clipsToBounds = true
        return textView
    }
}
