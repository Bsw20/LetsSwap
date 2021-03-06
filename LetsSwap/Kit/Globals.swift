//
//  Globals.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 02.02.2021.
//

import Foundation
import UIKit

func onMainThread(delay: TimeInterval = 0, _ block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { block() }
}

typealias StringURL = String?
public var screenSize: CGRect {
    return UIScreen.main.bounds
}

protocol StateTrackerDelegate: NSObjectProtocol {
    func stateDidChange()
}
