//
//  FeedOrderInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedOrderBusinessLogic {
  func makeRequest(request: FeedOrder.Model.Request.RequestType)
}

class FeedOrderInteractor: FeedOrderBusinessLogic {

    var presenter: FeedOrderPresentationLogic?
    private var fetcher: FeedOrderFetcher = UserAPIService.shared
    private var swapsManager: SwapsFetcher = SwapsManager()
  
    func makeRequest(request: FeedOrder.Model.Request.RequestType) {
        switch request {
        
        case .tryToDelete(orderId: let orderId):
            fetcher.deleteOrder(orderId: orderId) { [weak self](result) in
                self?.presenter?.presentData(response: .presentDeleting(result))
            }
        case .changeHidingState(orderId: let orderId):
            fetcher.changeHidingState(orderId: orderId) { (result) in
                self.presenter?.presentData(response: .presentNewHidingState(result))
            }
        case .validateSwap(orderId: let orderId):
            swapsManager.validateSwap(orderId: orderId) { (result) in
                self.presenter?.presentData(response: .presentSwapping(result))
            }
        case .reloadWholeData(orderId: let orderId):
            fetcher.getOrder(orderId: orderId) { (result) in
                self.presenter?.presentData(response: .presentUpdatedData(result))
            }
        }
    }
  
}
