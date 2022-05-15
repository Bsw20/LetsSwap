//
//  UIFont + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit

extension UIFont {
    static func circeRegular(with size: CGFloat) -> UIFont {
        return UIFont.init(name: "Circe-Regular", size: size)!
    }
    
    static func circeBold(with size: CGFloat) -> UIFont {
        return UIFont.init(name: "Circe-Bold", size: size)!
    }
}
