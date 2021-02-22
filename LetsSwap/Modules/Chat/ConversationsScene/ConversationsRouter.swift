//
//  ConversationsRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ConversationsRoutingLogic {
    func routeToChat()
}

class ConversationsRouter: NSObject, ConversationsRoutingLogic {
    

    weak var viewController: ConversationsViewController?
  
    // MARK: Routing
    func routeToChat() {
        let vc = ChatViewController()
        viewController?.navigationController?.push(vc)
    }
  
}
