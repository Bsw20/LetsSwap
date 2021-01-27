//
//  SignUpInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpBusinessLogic {
  func makeRequest(request: SignUp.Model.Request.RequestType)
}

class SignUpInteractor: SignUpBusinessLogic {

  var presenter: SignUpPresentationLogic?
  var service: SignUpService?
  
  func makeRequest(request: SignUp.Model.Request.RequestType) {
    if service == nil {
      service = SignUpService()
    }
  }
  
}
