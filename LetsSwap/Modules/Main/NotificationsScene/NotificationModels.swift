//
//  NotificationModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

enum Notification {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
      }
    }
    struct Response {
      enum ResponseType {
        case some
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
      }
    }
  }
  
}

enum NotificationType: CaseIterable {
    case unmatched
    case matched
}
