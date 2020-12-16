//
//  FeedPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedPresentationLogic {
  func presentData(response: Feed.Model.Response.ResponseType)
}

class FeedPresenter: FeedPresentationLogic {
  weak var viewController: FeedDisplayLogic?
  
  func presentData(response: Feed.Model.Response.ResponseType) {
  
  }
  
}
