//
//  UIViewController + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

extension UIViewController {
    static func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        UIApplication.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    var topbarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
}

