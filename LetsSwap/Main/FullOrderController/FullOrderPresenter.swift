//
//  FullOrderPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FullOrderPresentationLogic {
    func presentData(response: FullOrder.Model.Response.ResponseType)
}

class FullOrderPresenter: FullOrderPresentationLogic {
    weak var viewController: FullOrderDisplayLogic?
  
    func presentData(response: FullOrder.Model.Response.ResponseType) {
  
    }
}
