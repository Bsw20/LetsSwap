//
//  UIApplication + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.02.2021.
//

import Foundation
import UIKit

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController{
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    static func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        if let topViewController = UIApplication.getTopViewController() {
            if let oldAlertController = topViewController as? UIAlertController {
                
                if (oldAlertController.message?.contains("Ошибка") ?? false) && message.contains("Ошибка") {
                    oldAlertController.dismiss(animated: false) {
                        DispatchQueue.main.async {
                            UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    oldAlertController.present(alertController, animated: true, completion: nil)
                }
            } else {
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
