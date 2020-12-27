//
//  ChooseOrderError.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//

import Foundation
import UIKit
#warning("TODO: проработать все ошибки")
enum ChooseOrderError {
    case orderDoesntExist
    case orderAlreadyChosen
}

extension ChooseOrderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .orderDoesntExist:
            return NSLocalizedString("Данное предложение больше не существует", comment: "")
        case .orderAlreadyChosen:
            return NSLocalizedString("Предложение уже выбрано", comment: "")
        }
    }
}
