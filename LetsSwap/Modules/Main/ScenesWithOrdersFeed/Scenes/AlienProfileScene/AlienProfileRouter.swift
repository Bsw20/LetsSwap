//
//  AlienProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol AlienProfileRoutingLogic {
    func routeToFeedOrderController(orderViewModel: OrderViewModel)
}

class AlienProfileRouter: NSObject, AlienProfileRoutingLogic {

  weak var viewController: AlienProfileViewController?
  
  // MARK: Routing
    func routeToFeedOrderController(orderViewModel: OrderViewModel) {
        print(#function)
//        let vc = FeedOrderViewController(orderViewModel: orderViewModel)
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
