//
//  UIView + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

extension UIView {
    static func getRoundView(backgroundColor: UIColor, borderWidth: CGFloat, borderColor: CGColor) -> UIView{
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = backgroundColor
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.layer.cornerRadius = 23
        return view
    }
}
