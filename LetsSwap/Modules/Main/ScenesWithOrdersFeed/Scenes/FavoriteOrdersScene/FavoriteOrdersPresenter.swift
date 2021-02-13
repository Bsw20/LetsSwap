//
//  FavoriteOrdersPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FavoriteOrdersPresentationLogic {
  func presentData(response: FavoriteOrders.Model.Response.ResponseType)
}

class FavoriteOrdersPresenter: FavoriteOrdersPresentationLogic {
    weak var viewController: FavoriteOrdersDisplayLogic?
  
    func presentData(response: FavoriteOrders.Model.Response.ResponseType) {
        switch response {
        
        case .presentFeed(result: let result):
            switch result {
            
            case .success(let feed):
                let feedViewModel = FeedPresenter.getFeedViewModel(feed: feed)
                viewController?.displayData(viewModel: .displayFeed(feedViewModel: feedViewModel))
            case .failure(let feedError):
                viewController?.displayData(viewModel: .displayError(error: feedError))            }
        case .presentOrder(result: let result):
            switch result {
            
            case .success(let order):
                viewController?.displayData(viewModel: .displayOrder(orderViewModel: FeedPresenter.orderViewModel(from: order)))
            case .failure(let orderError):
                viewController?.displayData(viewModel: .displayError(error: orderError))
            }
        }
    }
}
