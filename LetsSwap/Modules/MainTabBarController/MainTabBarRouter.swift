//
//  MainTabBarRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MainTabBarRoutingLogic {
    func routeToChat(chatId: Int, navVC: UINavigationController)
}

class MainTabBarRouter: NSObject, MainTabBarRoutingLogic {

  weak var viewController: MainTabBarController?
  
  // MARK: Routing
    func routeToChat(chatId: Int, navVC: UINavigationController) {
        let vc = ChatViewController.init(conversation: nil, userInfo: nil, chatId: chatId)
        navVC.push(vc)
    }
}
