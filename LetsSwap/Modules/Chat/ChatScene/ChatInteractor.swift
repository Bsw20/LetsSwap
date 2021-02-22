//
//  ChatInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatBusinessLogic {
  func makeRequest(request: Chat.Model.Request.RequestType)
}

class ChatInteractor: ChatBusinessLogic {

  var presenter: ChatPresentationLogic?
  var service: ChatService?
  
  func makeRequest(request: Chat.Model.Request.RequestType) {
    if service == nil {
      service = ChatService()
    }
  }
  
}
