//
//  StateTrackerManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.02.2021.
//

import Foundation
import UIKit

struct StateTrackerManager {
    //MARK: - Variables
    private var controllersForSearching: [UINavigationController] = []
    public static var shared = StateTrackerManager()
    
    public mutating func generateNavigationController(viewController: UIViewController) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        controllersForSearching.append(navigationVC)
        return navigationVC
    }
    
}
