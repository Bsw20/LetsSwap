//
//  FullOrderInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FullOrderBusinessLogic {
  func makeRequest(request: FullOrder.Model.Request.RequestType)
}

private var service: FullOrderFetcher = UserAPIService.shared

class FullOrderInteractor: FullOrderBusinessLogic {

    var presenter: FullOrderPresentationLogic?
  
    func makeRequest(request: FullOrder.Model.Request.RequestType) {
        switch request {
        
        case .updateOrder(orderId: let orderId, model: let model):
            service.updateOrder(orderId: orderId, model: model) { (result) in
                self.presenter?.presentData(response: .presentUpdatingOrder(result: result))
            }
        case .createOrder(model: let model):
            service.createOrder(model: model) { (result) in
                self.presenter?.presentData(response: .presentCreatingOrder(result: result))
            }
        case .uploadImage(image: let image):
            service.uploadImage(image: image) { (result) in
                self.presenter?.presentData(response: .presentUploadingPhoto(result))
            }
        }
    }
}
