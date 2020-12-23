//
//  LittleRoundButton.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit

class LittleRoundButton: UIButton {
    class func newButton(backgroundColor: UIColor, text: String?, image: UIImage?, font: UIFont, textColor: UIColor) -> LittleRoundButton {
        let button = LittleRoundButton(type: .system)
        button.setup(backgroundColor: backgroundColor, text: text, image: image, font: font, textColor: textColor)
        return button
    }
    
    private func setup(backgroundColor: UIColor, text: String?, image: UIImage?, font: UIFont, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        setTitle(text, for: .normal)
        setImage(image, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 10
    }
}
