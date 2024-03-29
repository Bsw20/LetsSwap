//
//  UIViewController + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
import MessageKit

extension UIViewController {
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
    
    var topbarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

