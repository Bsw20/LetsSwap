//
//  AlienProfileError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

enum AlienProfileError {
    case emptyFeedError
    case serverError
    case unknownError
}

extension AlienProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyFeedError:
            return NSLocalizedString("На данный момент предложения недоступны", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
}
