//
//  FavoriteOrdersRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FavoriteOrdersRoutingLogic {
    func routeToFeedOrderController(orderViewModel: OrderViewModel)
}

class FavoriteOrdersRouter: NSObject, FavoriteOrdersRoutingLogic {

  weak var viewController: FavoriteOrdersViewController?
  
  // MARK: Routing
    func routeToFeedOrderController(orderViewModel: OrderViewModel) {
        let vc = FeedOrderViewController(type: .mainFeedOrder(model: orderViewModel))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
  
}
