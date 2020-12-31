//
//  UIColor + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//

import Foundation
import UIKit

extension UIColor {
    static func mainBackground() -> UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    }
    static func mainYellow() -> UIColor {
        return #colorLiteral(red: 1, green: 0.8431372549, blue: 0.1294117647, alpha: 1)
    }
    
    static func mainDetailsYellow() -> UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.8039215686, blue: 0, alpha: 1)
    }
    
    static func freeFeedCell() -> UIColor {
        return #colorLiteral(red: 1, green: 0.9333333333, blue: 0.6274509804, alpha: 1)
    }
    
    static func mainTextColor() -> UIColor {
        return #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
    }
    
    static func yellowTextColor() -> UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.7098039216, blue: 0.2352941176, alpha: 1)
    }
    
    static func greyTextColor() -> UIColor {
        return #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
    }
    
    static func detailsGrey() -> UIColor {
        return #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    }
    
    static func detailsYellow() -> UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.7098039216, blue: 0.2352941176, alpha: 1)
    }
}
