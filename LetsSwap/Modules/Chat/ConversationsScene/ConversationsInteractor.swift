//
//  ConversationsInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ConversationsBusinessLogic {
  func makeRequest(request: Conversations.Model.Request.RequestType)
}

class ConversationsInteractor: ConversationsBusinessLogic {

  var presenter: ConversationsPresentationLogic?
  var service: ConversationsService?
  
  func makeRequest(request: Conversations.Model.Request.RequestType) {
    if service == nil {
      service = ConversationsService()
    }
  }
  
}
