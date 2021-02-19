//
//  AlienProfileInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol AlienProfileBusinessLogic {
  func makeRequest(request: AlienProfile.Model.Request.RequestType)
}

class AlienProfileInteractor: AlienProfileBusinessLogic {

  var presenter: AlienProfilePresentationLogic?
  var service: AlienProfileService?
  
  func makeRequest(request: AlienProfile.Model.Request.RequestType) {
    if service == nil {
      service = AlienProfileService()
    }
    
    switch request {
    case .getProfile(userId: let userId):
        service?.getProfile(userId: userId, completion: { [weak self] (result) in
            self?.presenter?.presentData(response: .presentFullProfile(result: result))
        })
    case .getOrder(orderId: let orderId):
        service?.getOrder(orderId: orderId, completion: {[weak self] (result) in
            self?.presenter?.presentData(response: .presentOrder(result: result))
        } )
    }
  }
    
    
  
}
