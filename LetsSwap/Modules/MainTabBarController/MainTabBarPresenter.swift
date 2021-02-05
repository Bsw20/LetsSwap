//
//  MainTabBarPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MainTabBarPresentationLogic {
  func presentData(response: MainTabBar.Model.Response.ResponseType)
}

class MainTabBarPresenter: MainTabBarPresentationLogic {
  weak var viewController: MainTabBarDisplayLogic?
  
  func presentData(response: MainTabBar.Model.Response.ResponseType) {
  
  }
  
}
