//
//  MyProfileError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.01.2021.
//

import Foundation
import UIKit


enum MyProfileError {
    case APIUrlError
    case serverError
    case unknownError
    case incorrectDataModel
}

extension MyProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .APIUrlError:
            return NSLocalizedString("API request doesn't work", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .incorrectDataModel:
            return NSLocalizedString("Некорректная модель данных", comment: "")
        }
    }
}
