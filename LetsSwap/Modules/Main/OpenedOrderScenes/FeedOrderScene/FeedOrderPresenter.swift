//
//  FeedOrderPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020. All rights reserved.
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
            case .success(true):
                viewController?.displayData(viewModel: .displaySwapping)
            case .success(false):
                viewController?.displayData(viewModel: .displayAlert)
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        case .presentUpdatedData(let result):
            switch result {
            
            case .success(let model):
                viewController?.displayData(viewModel: .displayUpdatedData(model: getFeedOrderModel(data: model)))
            case .failure(_):
                viewController?.displayData(viewModel: .displayUpdatingDataError)
            }
        }
    }
    
    private func getFeedOrderModel(data: MyProfileOrderResponse) -> FeedOrderModel {
        let tags = data.tags.compactMap{FeedTag.init(rawValue: $0)}
        let urls = data.photoAttachments.compactMap{URL(string: $0)}
        return FeedOrderModel(videoAttachments: data.videoAttachments.compactMap{URL(string: $0)},
                              orderId: data.orderId,
                              title: data.title,
                              description: data.description,
                              counterOffer: data.counterOffer,
                              isFree: data.isFree,
                              tags: tags,
                              photoAttachments: urls,
                              isHidden: data.isHidden)
    }
  
}
