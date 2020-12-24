//
//  FeedOrderRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


protocol FeedOrderRoutingLogic {
    func routeToComments(commentsModel: CommentsViewModel)
}

class FeedOrderRouter: NSObject, FeedOrderRoutingLogic {
    func routeToComments(commentsModel: CommentsViewModel) {
        let vc = CommentViewController(commentsModel: commentsModel)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    weak var viewController: FeedOrderViewController?
  
  // MARK: Routing
  
}
