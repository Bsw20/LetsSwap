//
//  AlienProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum AlienProfile {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getProfile(userId: Int)
        case getOrder(orderId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentFullProfile(result: Result<ProfileResponse, AlienProfileError>)
        case presentOrder(result: Result<OrderResponse, OrderError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFullProfile(profileViewModel: ProfileViewModel)
        case displayOrder(orderViewModel: OrderViewModel)
        case displayError(error: Error)
      }
    }
  }
  
}
