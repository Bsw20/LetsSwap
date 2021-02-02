//
//  UIBarButtonItem + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 02.02.2021.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    public static func getTappableButton(target: Any?, action: Selector?, enabledImage: UIImage?, disabledImage: UIImage?, isEnabled: Bool = true) -> UIBarButtonItem {
        let button = TappableBarButtonItem(image: isEnabled ? enabledImage : disabledImage,
                                           style: .plain,
                                           target: target,
                                           action: action)
        button.setupImages(enabledImage: enabledImage, disabledImage: disabledImage)
        return button
    }
}

private class TappableBarButtonItem: UIBarButtonItem {
    private var enabledImage: UIImage?
    private var disabledImage: UIImage?
    
    override open var isEnabled: Bool {
        didSet {
            if isEnabled, let image = enabledImage {
                self.image = image
            }
            
            if !isEnabled, let image = disabledImage {
                self.image = image
            }
        }
    }
    
    public func setupImages(enabledImage: UIImage?, disabledImage: UIImage?) {
        self.enabledImage = enabledImage
        self.disabledImage = disabledImage
    }
}
