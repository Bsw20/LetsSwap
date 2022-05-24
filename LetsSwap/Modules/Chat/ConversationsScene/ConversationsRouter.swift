//
//  ConversationsRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol ConversationsRoutingLogic {
    func routeToChat(conversation: Conversations.Conversation, userInfo: Conversations.MyProfileInfo)
}

class ConversationsRouter: NSObject, ConversationsRoutingLogic {
    

    weak var viewController: ConversationsViewController?
  
    // MARK: Routing
    func routeToChat(conversation: Conversations.Conversation, userInfo: Conversations.MyProfileInfo) {
        let vc = ChatViewController(conversation: conversation, userInfo: userInfo, chatId: nil)
        //let vc = ChatViewController(conversation: nil, userInfo: nil, chatId: conversation.chatId)
        viewController?.navigationController?.push(vc)
    }
  
}
