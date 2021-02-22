//
//  ChatPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatPresentationLogic {
  func presentData(response: Chat.Model.Response.ResponseType)
}

class ChatPresenter: ChatPresentationLogic {
  weak var viewController: ChatDisplayLogic?
  
  func presentData(response: Chat.Model.Response.ResponseType) {
  
  }
  
}
