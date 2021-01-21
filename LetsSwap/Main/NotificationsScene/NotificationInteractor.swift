//
//  NotificationInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NotificationBusinessLogic {
  func makeRequest(request: Notification.Model.Request.RequestType)
}

class NotificationInteractor: NotificationBusinessLogic {

  var presenter: NotificationPresentationLogic?
  var service: NotificationService?
  
  func makeRequest(request: Notification.Model.Request.RequestType) {
    if service == nil {
      service = NotificationService()
    }
  }
  
}
