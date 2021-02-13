//
//  FeedInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedBusinessLogic {
  func makeRequest(request: Feed.Model.Request.RequestType)
}

class FeedInteractor: FeedBusinessLogic {

    var presenter: FeedPresentationLogic?
    var service: FeedService?
  
    func makeRequest(request: Feed.Model.Request.RequestType) {
        if service == nil {
            service = FeedService()
        }
        switch request {
        
        case .getFeed:
            service?.getFeed(completion: { [weak self] (result) in
                self?.presenter?.presentData(response: .presentFeed(result: result))
            })
        case .getFilteredFeed(model: let model):
            service?.getFiltredFeed(model: model, completion: { [weak self](result) in
                self?.presenter?.presentData(response: .presentFeed(result: result))
            })
        case .getOrder(orderId: let orderId):
            service?.getOrder(orderId: orderId, completion: {[weak self] (result) in
                self?.presenter?.presentData(response: .presentOrder(result: result))
            } )
        }
    
  }
}
