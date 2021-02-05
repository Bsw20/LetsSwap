//
//  FullOrderInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FullOrderBusinessLogic {
  func makeRequest(request: FullOrder.Model.Request.RequestType)
}

class FullOrderInteractor: FullOrderBusinessLogic {

    var presenter: FullOrderPresentationLogic?
  
    func makeRequest(request: FullOrder.Model.Request.RequestType) {

    }
}
