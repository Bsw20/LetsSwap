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
}

class ConversationsPresenter: ConversationsPresentationLogic {
  weak var viewController: ConversationsDisplayLogic?
  
  func presentData(response: Conversations.Model.Response.ResponseType) {
  
  }
  
}
