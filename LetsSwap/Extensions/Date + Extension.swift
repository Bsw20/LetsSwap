//
//  Date + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.02.2021.
//

import Foundation
import UIKit

extension Date {
//    func localTime() -> Date {
//        let timezone = TimeZone.current
//        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
//        return Date(timeInterval: seconds, since: self)
//    }
    
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
