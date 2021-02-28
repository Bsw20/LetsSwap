//
//  FavoriteOrdersInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FavoriteOrdersBusinessLogic {
    func makeRequest(request: FavoriteOrders.Model.Request.RequestType)
}

class FavoriteOrdersInteractor: FavoriteOrdersBusinessLogic {
    private var fetcher: FeedDataFetcher = NetworkDataFetcher.shared
    var presenter: FavoriteOrdersPresentationLogic?
    private var newFromInProcess: String? //Для запроса новой пачки предложений
  
    func makeRequest(request: FavoriteOrders.Model.Request.RequestType) {
        switch request {
        case .getFeed:
            fetcher.getFavoriteOrdersFeed(nextBatchFrom: nil) {[weak self] (result) in
                switch result {
                
                case .success(let model):
                    self?.newFromInProcess = model.nextFrom
                case .failure(_):
                    break
                }
                self?.presenter?.presentData(response: .presentFeed(result: result))
            }
        case .getOrder(orderId: let orderId):
            fetcher.getOrder(orderId: orderId){[weak self] (result) in
                self?.presenter?.presentData(response: .presentOrder(result: result))
            }
        }
    }
}
