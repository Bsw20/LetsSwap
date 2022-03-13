//
//  ChatPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol ChatPresentationLogic {
    func presentAllMessages(model: Chat.AllMessages.Response)
    func presentError(error: Error)
}

class ChatPresenter: ChatPresentationLogic {
    func presentAllMessages(model: Chat.AllMessages.Response) {
//        viewController?.displayAllMessages(model: <#T##Chat.AllMessages.ViewModel#>)
        viewController?.displayAllMessages(model: .init(messages: model.messages))
    }
    
    func presentError(error: Error) {
        viewController?.displayError(error: error)
    }
    
  weak var viewController: ChatDisplayLogic?
}
