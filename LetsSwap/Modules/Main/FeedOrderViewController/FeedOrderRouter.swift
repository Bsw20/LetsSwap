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
    func routToAlienProfile(userId: Int)
}

class FeedOrderRouter: NSObject, FeedOrderRoutingLogic {
    func routToAlienProfile(userId: Int) {
        let vc = AlienProfileViewController(userId: userId)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToComments(commentsModel: CommentsViewModel) {
        let vc = CommentViewController(commentsModel: commentsModel)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    weak var viewController: FeedOrderViewController?
  
  // MARK: Routing
  
}
