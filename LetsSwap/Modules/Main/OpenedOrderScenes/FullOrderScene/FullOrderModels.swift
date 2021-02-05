//
//  FullOrderModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

enum FullOrder {
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

struct FullOrderViewModel {
    var title: String
    var description: String
    var isFree: Bool
    var counterOffer: String
    var tags: [String]
    var id: Int?
    var photoAttachments: [String]
    
    var representation: [String: Any] {
        var rep: [String: Any]  = ["title": title]
        rep["description"] = description
        rep["isFree"] = isFree
        rep["counterOffer"] = counterOffer
        rep["tags"] = tags
        
        return rep
    }
}
