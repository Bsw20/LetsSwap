//
//  SignInPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInPresentationLogic {
  func presentData(response: SignIn.Model.Response.ResponseType)
}

class SignInPresenter: SignInPresentationLogic {
  weak var viewController: SignInDisplayLogic?
  
  func presentData(response: SignIn.Model.Response.ResponseType) {
  
  }
  
}
