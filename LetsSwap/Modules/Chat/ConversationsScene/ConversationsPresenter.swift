//
//  ConversationsPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol ConversationsPresentationLogic {
  func presentData(response: Conversations.Model.Response.ResponseType)
    func presentAllConversations(response: Conversations.AllConversations.Response)
    func presentError(error: Error)
}

class ConversationsPresenter: ConversationsPresentationLogic {

    
    
    weak var viewController: ConversationsDisplayLogic?

    func presentData(response: Conversations.Model.Response.ResponseType) {

    }
    
    func presentAllConversations(response: Conversations.AllConversations.Response) {
        viewController?.displayAllConversations(viewModel: .init(chats: response.chats,
                                                                 myId: response.myId,
                                                                 myProfileImage: response.myProfileImage,
                                                                 myUserName: response.myUserName))
    }
    
    func presentError(error: Error) {
        viewController?.displayError(error: error)
    }
  
}
