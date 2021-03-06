//
//  FeedRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedRoutingLogic {
    func routeToTagsController(currentTags: Set<FeedTag>)
    func routeToFeedOrderController(orderViewModel: OrderViewModel)
    func routeToCitiesController()
}

class FeedRouter: NSObject, FeedRoutingLogic {
    func routeToCitiesController() {
        #warning("TODO ")
        let vc = CitiesListViewController(selectedCity: City.getCities()[0])
        viewController?.navigationController?.pushViewController( vc, animated: true)
    }
    
    func routeToTagsController(currentTags: Set<FeedTag>) {
        let vc = TagsViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToFeedOrderController(orderViewModel: OrderViewModel) {
        let vc = FeedOrderViewController(type: .mainFeedOrder(model: orderViewModel))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

  weak var viewController: FeedViewController?
  
  // MARK: Routing
  
}
