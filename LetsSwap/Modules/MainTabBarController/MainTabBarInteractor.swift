//
//  MainTabBarInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MainTabBarBusinessLogic {
  func makeRequest(request: MainTabBar.Model.Request.RequestType)
}

class MainTabBarInteractor: MainTabBarBusinessLogic {

  var presenter: MainTabBarPresentationLogic?
  var service: MainTabBarService?
  
  func makeRequest(request: MainTabBar.Model.Request.RequestType) {
    if service == nil {
      service = MainTabBarService()
    }
  }
  
}
