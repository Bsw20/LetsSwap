//
//  AlienProfilePresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol AlienProfilePresentationLogic {
  func presentData(response: AlienProfile.Model.Response.ResponseType)
    func presentFullModel(result: AlienProfile.FullModel.Response)
}

class AlienProfilePresenter: AlienProfilePresentationLogic {
    func presentFullModel(result: AlienProfile.FullModel.Response) {
        switch result.model {
        
        case .success(let model):
            let viewModel = AlienProfile.FullModel.ViewModel(model: model)
            viewController?.displayFullModel(viewModel: viewModel)
        case .failure(let error):
            viewController?.displayData(viewModel: .displayError(error: error))
        }
    }
    
  weak var viewController: AlienProfileDisplayLogic?
  
  func presentData(response: AlienProfile.Model.Response.ResponseType) {
    switch response {
    case .presentOrder(result: let result):
        switch result {
        
        case .success(let order):
            viewController?.displayData(viewModel: .displayOrder(orderViewModel: FeedPresenter.orderViewModel(from: order)))
        case .failure(let orderError):
            viewController?.displayData(viewModel: .displayError(error: orderError))
        }
    }
  }
    static func getProfileDescriptionViewModel(profileDescription: ProfileDescription) -> ProfileDescriptionViewModel{
        var url: URL? = nil
        if let stringURL = profileDescription.userPhoto?.url{
            url = URL(string: stringURL)
        }
        
        return ProfileDescriptionViewModel.init(userPhoto: url,
                                                swapsCount: profileDescription.swapsCount,
                                                rating: profileDescription.rating,
                                                name: profileDescription.name,
                                                lastName: profileDescription.lastName,
                                                cityName: profileDescription.cityName)
    }
}
