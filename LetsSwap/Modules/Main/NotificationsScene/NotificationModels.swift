//
//  NotificationModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import RealmSwift

enum SwapNotification {
    enum NotificationType {
        case unmatched
        case matched
        case mvpVersion(model: AllNotifications.Notification)
    }
    

    enum AllNotifications {
        class Notification: Object, Decodable {
            dynamic var comment = ""
            dynamic var desc = ""
            dynamic var image = ""
            dynamic var name = ""
            dynamic var lastname = ""
            dynamic var orderId = 0
            dynamic var status = ""
            dynamic var userId = 0
            dynamic var swapId = 0
        }
        struct Request {
        }
        
        struct Response: Decodable {
            var offers: [Notification]
        }
        
        struct ViewModel: Decodable {
            var offers: [Notification]
        }
    }
    
        
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
