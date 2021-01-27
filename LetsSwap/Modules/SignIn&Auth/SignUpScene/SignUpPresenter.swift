//
//  SignUpPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpPresentationLogic {
  func presentData(response: SignUp.Model.Response.ResponseType)
}

class SignUpPresenter: SignUpPresentationLogic {
  weak var viewController: SignUpDisplayLogic?
  
  func presentData(response: SignUp.Model.Response.ResponseType) {
  
  }
  
}
