//
//  FeedOrderInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedOrderBusinessLogic {
  func makeRequest(request: FeedOrder.Model.Request.RequestType)
}

class FeedOrderInteractor: FeedOrderBusinessLogic {

  var presenter: FeedOrderPresentationLogic?
  var service: FeedOrderService?
  
  func makeRequest(request: FeedOrder.Model.Request.RequestType) {
    if service == nil {
      service = FeedOrderService()
    }
  }
  
}
