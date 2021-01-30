//
//  AuthError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.01.2021.
//

import Foundation
import UIKit

enum AuthError {
    case APIUrlError
    case serverError
    case unknownError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .APIUrlError:
            return NSLocalizedString("API request doesn't work", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
}
