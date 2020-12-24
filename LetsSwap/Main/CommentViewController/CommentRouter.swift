//
//  CommentRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CommentRoutingLogic {
    func routeToRequestSentViewController()
}

class CommentRouter: NSObject, CommentRoutingLogic {
    func routeToRequestSentViewController() {
        let vc = RequestSentViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

  weak var viewController: CommentViewController?
  
  // MARK: Routing
  
}
