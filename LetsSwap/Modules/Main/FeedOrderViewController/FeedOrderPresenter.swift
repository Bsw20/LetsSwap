//
//  FeedOrderPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedOrderPresentationLogic {
    func presentData(response: FeedOrder.Model.Response.ResponseType)
}

class FeedOrderPresenter: FeedOrderPresentationLogic {
    weak var viewController: FeedOrderDisplayLogic?
  
    func presentData(response: FeedOrder.Model.Response.ResponseType) {
        
    }
  
}
