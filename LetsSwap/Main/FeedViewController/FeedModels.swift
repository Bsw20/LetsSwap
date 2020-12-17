//
//  FeedModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Feed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getFeed
      }
    }
    struct Response {
      enum ResponseType {
        case presentFeed(result: Result<FeedResponse, FeedError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFeed(feedViewModel: FeedViewModel)
        case displayError(error: Error)
        case displayEmptyFeed
      }
    }
  }
  
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        
        var title: String
        var description: String
        var counterOffer: String
        var photo: URL?
        var isFavourite: Bool
        var isFree: Bool
    }
    
    let cells: [Cell]
}
