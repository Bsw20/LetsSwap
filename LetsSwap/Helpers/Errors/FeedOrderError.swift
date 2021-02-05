//
//  FeedOrderError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 06.02.2021.
//

import UIKit

enum FeedOrderError {
    case APIUrlError
    case serverError
    case unknownError
}

extension FeedOrderError: LocalizedError {
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
