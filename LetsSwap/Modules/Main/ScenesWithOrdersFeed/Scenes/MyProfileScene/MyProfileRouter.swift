//
//  MyProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfileRoutingLogic {
    func routeToEditScreen()
    func routeToCreateOrder()
    func routeToOpenOrder(orderModel: FeedOrderModel)
}

class MyProfileRouter: NSObject, MyProfileRoutingLogic {

    

    weak var viewController: MyProfileViewController?
    
  
  // MARK: Routing
    func routeToOpenOrder(orderModel: FeedOrderModel) {
        let vc = FeedOrderViewController(type: .myProfileOrder(model: orderModel))
        viewController?.navigationController?.push(vc)
    }
    func routeToEditScreen() {
        let vc = EditProfileViewController(viewModel: EditProfileViewModel(name: "Ярослав", lastname: "Карпунькин", city: "Санкт-Петербург", phoneNumber: "89858182278", imageStringUrl: "https://hsto.org/getpro/habr/post_images/6d4/e15/1a5/6d4e151a581298d9976496d8fbb7f74e.jpg"))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCreateOrder() {
        let vc = FullOrderViewController(type: .create)
        viewController?.navigationController?.push(vc)
    }
  
}
