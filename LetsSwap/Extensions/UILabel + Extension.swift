//
//  UILabel + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//

import Foundation
import UIKit

extension UILabel {
    static func getNormalLabel(fontSize: CGFloat, text: String, textColor: UIColor = .mainTextColor()) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor
        label.font = UIFont.circeRegular(with: fontSize)
        label.text = text
        return label
    }
}
