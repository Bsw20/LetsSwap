//
//  NotificationModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

enum Notification {
    enum NotificationType {
        case unmatched
        case matched
        case mvpVersion(model: AllNotifications.Notification)
    }
    

    enum AllNotifications {
        struct Notification: Decodable {
            var comment: String
            var description: String
            var image: String?
            var name: String
            var lastname: String
            var orderId: Int
            var status: String
            var userId: Int
            var swapId: Int
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
