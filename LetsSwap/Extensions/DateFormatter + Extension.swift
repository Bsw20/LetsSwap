//
//  DateFormatter + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.02.2021.
//

import Foundation
import UIKit

extension DateFormatter {
    static let timestampWithTimeZone: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
    

}
