//
//  UIButton + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(image: UIImage? = nil, backgroundColor: UIColor, cornerRadius: CGFloat,
                     isShadow: Bool = false, borderColor: UIColor, borderWidth: CGFloat = 1){
        self.init(type: .system)
        if let image = image {
            setImage(image, for: .normal)
        }
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
        
        
    }
}
