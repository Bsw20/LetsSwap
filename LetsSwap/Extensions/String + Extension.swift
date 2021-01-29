//
//  String + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let frame = (self as NSString).size(withAttributes: fontAttributes)
        
        let textpreSize = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textpreSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: fontAttributes,
                                     context: nil)
        return CGSize(width: size.width, height: ceil(size.height))
    }
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
