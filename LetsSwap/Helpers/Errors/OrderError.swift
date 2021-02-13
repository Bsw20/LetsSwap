//
//  OrderError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//

import Foundation
import UIKit

#warning("TODO: проработать все ошибки")
enum OrderError {
    case orderDoesntExist
    case serverError
    case userDoesntExist
    case incorrectDataModel
    case incorrectUrlError
}

extension OrderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .orderDoesntExist:
            return NSLocalizedString("Данное предложение сейчас недоступно", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .userDoesntExist:
            return NSLocalizedString("Человек, который создал это предложение, сейчас недоступен", comment: "")
        case .incorrectDataModel:
            return NSLocalizedString("Некорректная модель данных", comment: "")
        case .incorrectUrlError:
            return NSLocalizedString("Некорректный url запроса", comment: "")
        }
    }
}

