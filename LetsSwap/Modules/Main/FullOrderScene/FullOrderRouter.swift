//
//  FullOrderRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FullOrderRoutingLogic {
    func routeToTagsList(selectedTags: Set<FeedTag>)
}

class FullOrderRouter: NSObject, FullOrderRoutingLogic {

    weak var viewController: FullOrderViewController?
  
    // MARK: Routing
    func routeToTagsList(selectedTags: Set<FeedTag>) {
        let vc = TagsListViewController(selectedTags: selectedTags)
        vc.customDelegate = viewController
        viewController?.navigationController?.push(vc)
    }
    
}
