//
//  MyProfilePresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MyProfilePresentationLogic {
  func presentData(response: MyProfile.Model.Response.ResponseType)
}

class MyProfilePresenter: MyProfilePresentationLogic {
    weak var viewController: MyProfileDisplayLogic?
  
    func presentData(response: MyProfile.Model.Response.ResponseType) {
        switch response {
        case .presentWholeProfile(result: let result):
            switch result {
            
            case .success(let data):
                viewController?.displayData(viewModel: .displayWholeProfile(myProfileViewModel: data))
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        case .presentOrder(result: let result):
            switch result {
            case .success(let data):
                let model = getFeedOrderModel(data: data)
                viewController?.displayData(viewModel: .displayOrder(orderModel: model))
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        case .presentFullProfileInfo(result: let result):
            switch result {
            
            case .success(let model):
                viewController?.displayData(viewModel: .displayFullProfileInfo(profileInfo: model))
            case .failure(let error):
                viewController?.displayData(viewModel: .displayError(error: error))
            }
        }
    }
}

//MARK: - mapping
extension MyProfilePresenter {
    private func getFeedOrderModel(data: MyProfileOrderResponse) -> FeedOrderModel {
        let tags = data.tags.compactMap{FeedTag.init(rawValue: $0)}
        let urls = data.photoAttachments.compactMap{URL(string: $0)}
        return FeedOrderModel(orderId: data.orderId,
                              title: data.title,
                              description: data.description,
                              counterOffer: data.counterOffer,
                              isFree: data.isFree,
                              tags: tags,
                              photoAttachments: urls,
                              isHidden: data.isHidden)
    }
}
