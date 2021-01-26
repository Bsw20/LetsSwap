//
//  NotificationPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NotificationPresentationLogic {
  func presentData(response: Notification.Model.Response.ResponseType)
}

class NotificationPresenter: NotificationPresentationLogic {
  weak var viewController: NotificationDisplayLogic?
  
  func presentData(response: Notification.Model.Response.ResponseType) {
  
  }
  
}
