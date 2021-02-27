//
//  AlienProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

enum AlienProfile {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getOrder(orderId: Int)
      }
    }
    struct Response {
      enum ResponseType {
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
    
    enum FullModel {
        struct Wrapper: Decodable {
            struct PersonInfo: Decodable {
                var cityName: String
                var lastname: String
                var name: String
                var profileImage: String?
                var raiting: Double
                var swapsCount: Int
            }
            struct Order: Decodable {
                var counterOffer: String
                var description: String
                var isFree: Bool
                var isHidden: Bool
                var orderId: Int
                var photo: String?
                var title: String
            }
            var personInfo: PersonInfo
            var feedInfo: [Order]
        }
        
        struct Request {
            var userId: Int
        }
        struct Response {
            var model: Result<Wrapper, NSError>
        }
        
        struct ViewModel {
            var model: Wrapper
        }
    }
  
}
