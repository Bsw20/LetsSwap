//
//  FavoriteOrdersModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum FavoriteOrders {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getFeed
        case getOrder(orderId: Int)

      }
    }
    struct Response {
      enum ResponseType {
        case presentFeed(result: Result<FeedResponse, FeedError>)
        case presentOrder(result: Result<OrderResponse, OrderError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFeed(feedViewModel: FeedViewModel)
        case displayError(error: Error)
        case displayOrder(orderViewModel: OrderViewModel)
      }
    }
  }
  
}
