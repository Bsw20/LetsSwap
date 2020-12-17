//
//  FeedError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
#warning("TODO: проработать все ошибки")
enum FeedError {
    case emptyFeedError
    case serverError
    case unknownError
}

extension FeedError: LocalizedError {
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
