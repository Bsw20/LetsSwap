//
//  MyProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MyProfileRoutingLogic {
    func routeToEditScreen(model: EditProfileViewModel)
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
    func routeToEditScreen(model: EditProfileViewModel) {
        let vc = EditProfileViewController(viewModel: model)
        print("MODEL HERE")
        print(model)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCreateOrder() {
        let vc = FullOrderViewController(type: .create)
        viewController?.navigationController?.push(vc)
    }
  
}
