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
}
