//
//  SignInInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInBusinessLogic {
  func makeRequest(request: SignIn.Model.Request.RequestType)
}

class SignInInteractor: SignInBusinessLogic {

  var presenter: SignInPresentationLogic?
  var service: SignInService?
  
  func makeRequest(request: SignIn.Model.Request.RequestType) {
    if service == nil {
      service = SignInService()
    }
  }
  
}
