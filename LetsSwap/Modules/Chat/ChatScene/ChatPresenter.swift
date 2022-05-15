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
    func presentData(model: MyProfileViewModel.PersonInfo)
    func closeView()
}

class ChatPresenter: ChatPresentationLogic {
    func presentData(model: MyProfileViewModel.PersonInfo) {
        viewController?.displayData(viewModel: model)
    }
    
    func presentAllMessages(model: Chat.AllMessages.Response) {
        viewController?.displayAllMessages(model: .init(messages: model.messages))
    }
    
    func presentError(error: Error) {
        viewController?.displayError(error: error)
    }
    
    func closeView() {
        viewController?.closeView()
    }
  weak var viewController: ChatDisplayLogic?
}
