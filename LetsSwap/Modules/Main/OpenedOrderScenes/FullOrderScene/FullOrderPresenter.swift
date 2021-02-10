//
//  FullOrderPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FullOrderPresentationLogic {
    func presentData(response: FullOrder.Model.Response.ResponseType)
}

class FullOrderPresenter: FullOrderPresentationLogic {
    weak var viewController: FullOrderDisplayLogic?
  
    func presentData(response: FullOrder.Model.Response.ResponseType) {
        switch response {
        case .presentCreatingOrder(result: let result):
            switch result {
            
            case .success():
                viewController?.displayData(viewModel: .displayOrderCreated)
            case .failure(let error):
                viewController?.displayData(viewModel: .showErrorAlert(title: "Ошибка!", message: error.localizedDescription))
            }
        case .presentUpdatingOrder(result: let result):
            switch result {
            
            case .success():
                viewController?.displayData(viewModel: .displayOrderUpdated)
            case .failure(let error):
                viewController?.displayData(viewModel: .showErrorAlert(title: "Ошибка!", message: error.localizedDescription))
            }
        case .presentUploadingPhoto(let result):
            switch result {
            
            case .success(let stringURL):
                if let stringURL = stringURL {
                    viewController?.displayData(viewModel: .displayUploadedPhoto(photoUrl: stringURL))
                } else {
                    viewController?.displayData(viewModel: .showErrorAlert(title: "Ошибка!", message: "Ошибка сервера"))
                }

            case .failure(let error):
                viewController?.displayData(viewModel: .showErrorAlert(title: "Ошибка!", message: error.localizedDescription))
            }
        }
    }
}
