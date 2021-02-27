//
//  AlienProfileInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import SwiftyBeaver
protocol AlienProfileBusinessLogic {
  func makeRequest(request: AlienProfile.Model.Request.RequestType)
    func getFullModel(request: AlienProfile.FullModel.Request)
}

class AlienProfileInteractor: AlienProfileBusinessLogic {

    

  var presenter: AlienProfilePresentationLogic?
  var service: AlienProfileService?
    
    func getFullModel(request: AlienProfile.FullModel.Request) {
        if service == nil {
          service = AlienProfileService()
        }
        service?.getFullModel(requestModel: request, completion: { [weak self](result) in
            switch result {
            
            case .success(let model):
                self?.presenter?.presentFullModel(result: model)
            case .failure(let error):
                self?.presenter?.presentFullModel(result: .init(model: .failure(error as NSError)))
            }
        })
    }
  
  func makeRequest(request: AlienProfile.Model.Request.RequestType) {
    if service == nil {
      service = AlienProfileService()
    }
    
    switch request {
    case .getOrder(orderId: let orderId):
        service?.getOrder(orderId: orderId, completion: {[weak self] (result) in
            self?.presenter?.presentData(response: .presentOrder(result: result))
        } )
    }
  }
    
    
  
}
