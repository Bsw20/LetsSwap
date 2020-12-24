//
//  FeedRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedRoutingLogic {
    func routeToTagsController(currentTags: Set<FeedTag>)
    func routeToFeedOrderController(orderViewModel: OrderViewModel)
    func routeToCitiesController()
}

class FeedRouter: NSObject, FeedRoutingLogic {
    func routeToCitiesController() {
        print("route to cities contrller")
    }
    
    func routeToTagsController(currentTags: Set<FeedTag>) {
        let vc = TagsViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToFeedOrderController(orderViewModel: OrderViewModel) {
        print("routing to feed order")
        let vc = FeedOrderViewController(orderViewModel: orderViewModel)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

  weak var viewController: FeedViewController?
  
  // MARK: Routing
  
}
