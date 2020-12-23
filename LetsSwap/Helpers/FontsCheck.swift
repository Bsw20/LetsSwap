//
//  FontsCheck.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.12.2020.
//

import Foundation
import UIKit

class FontsCheck {
    static func checkFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}
