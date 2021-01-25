//
//  MyProfilePresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfilePresentationLogic {
  func presentData(response: MyProfile.Model.Response.ResponseType)
}

class MyProfilePresenter: MyProfilePresentationLogic {
  weak var viewController: MyProfileDisplayLogic?
  
  func presentData(response: MyProfile.Model.Response.ResponseType) {
  
  }
  
}
