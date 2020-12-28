//
//  AlienProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AlienProfileRoutingLogic {
    func routeToFeedOrderController(orderViewModel: OrderViewModel)
}

class AlienProfileRouter: NSObject, AlienProfileRoutingLogic {

  weak var viewController: AlienProfileViewController?
  
  // MARK: Routing
    func routeToFeedOrderController(orderViewModel: OrderViewModel) {
        print("routing to feed order")
        let vc = FeedOrderViewController(orderViewModel: orderViewModel)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
