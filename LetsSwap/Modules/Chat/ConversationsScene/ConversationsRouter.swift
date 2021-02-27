//
//  ConversationsRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ConversationsRoutingLogic {
    func routeToChat(chatId: Int)
}

class ConversationsRouter: NSObject, ConversationsRoutingLogic {
    

    weak var viewController: ConversationsViewController?
  
    // MARK: Routing
    func routeToChat(chatId: Int) {

//        let vc = ChatViewController(chatId: chatId)
//        viewController?.navigationController?.push(vc)
    }
  
}
