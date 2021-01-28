//
//  NavigationController + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.01.2021.
//

import Foundation
import UIKit

extension UINavigationController {
    func setupAsBaseScreen(_ controller: UIViewController, animated: Bool) {
        self.setViewControllers([controller], animated: animated)
    }
}
