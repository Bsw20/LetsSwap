//
//  FeedOrderRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit


protocol FeedOrderRoutingLogic {
    func routeToComments(commentsModel: CommentsViewModel)
    func routToAlienProfile(userId: Int)
    func routeToEditOrder(model: FeedOrderModel)
}

class FeedOrderRouter: NSObject, FeedOrderRoutingLogic {
    
    weak var viewController: FeedOrderViewController?
  
  // MARK: Routing
    func routToAlienProfile(userId: Int) {
        let vc = AlienProfileViewController(userId: userId)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToComments(commentsModel: CommentsViewModel) {
        let vc = CommentViewController(commentsModel: commentsModel)
        vc.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToEditOrder(model: FeedOrderModel) {
        let orderViewModel = FullOrderViewModel(title: model.title,
                                                description: model.description,
                                                isFree: model.isFree,
                                                counterOffer: model.counterOffer,
                                                tags: model.tags.map{$0.rawValue},
                                                id: model.orderId,
                                                photoAttachments: model.photoAttachments.compactMap{$0.absoluteString})
        let vc = FullOrderViewController(type: .edit(model: orderViewModel))
        viewController?.navigationController?.push(vc)
    }
  
}
