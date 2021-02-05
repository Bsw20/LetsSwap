//
//  FeedOrderPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedOrderPresentationLogic {
    func presentData(response: FeedOrder.Model.Response.ResponseType)
}

class FeedOrderPresenter: FeedOrderPresentationLogic {
    weak var viewController: FeedOrderDisplayLogic?
  
    func presentData(response: FeedOrder.Model.Response.ResponseType) {
        switch response {
        case .presentDeleting(let result):
            switch result {
            case .success:
                viewController?.displayData(viewModel: .displayDeleting)
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        case .presentNewHidingState(let result):
            switch result {
            case .success(let state):
                viewController?.displayData(viewModel: .displayNewHidingState(newState: state))
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        case .presentSwapping(let result):
            switch result {
            case .success():
                viewController?.displayData(viewModel: .displaySwapping)
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        }
    }
  
}
