//
//  MyProfileInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfileBusinessLogic {
  func makeRequest(request: MyProfile.Model.Request.RequestType)
}

class MyProfileInteractor: MyProfileBusinessLogic {

  var presenter: MyProfilePresentationLogic?
  var service: MyProfileService?
  
  func makeRequest(request: MyProfile.Model.Request.RequestType) {
    if service == nil {
      service = MyProfileService()
    }
  }
  
}