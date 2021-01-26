//
//  MyProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum MyProfile {
   
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

struct MyProfileViewModel {
    struct PersonInfo {
        var profileImage: URL?
        var name: String
        var cityName: String
        var swapsCount: Int
        var raiting: Double
    }
    
    struct FeedModel {
        struct Cell: Hashable, BaseFeedCellViewModel {
            
            var orderId: Int
            
            var title: String
            var description: String
            var counterOffer: String
            var photo: URL?
            var isFree: Bool
            var isHidden: Bool
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(orderId)
            }
            
            static func == (lhs: FeedModel.Cell, rhs: FeedModel.Cell) -> Bool {
                return lhs.orderId == rhs.orderId
            }
        }
        
        let cells: [Cell]
    }
    
    var personInfo: PersonInfo
    var feedInfo: FeedModel
    
}
