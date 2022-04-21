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
                case updateOrder(orderId: Int, model: FullOrderViewModel)
                case createOrder(model: FullOrderViewModel)
                case uploadImage(image: UIImage)
            }
        }
        struct Response {
            enum ResponseType {
                case presentUpdatingOrder(result: Result<Void, MyProfileError>)
                case presentCreatingOrder(result: Result<Void, MyProfileError>)
                case presentUploadingPhoto(Result<StringURL, MyProfileError>)
            }
            
        }
        struct ViewModel {
            enum ViewModelData {
                case displayOrderCreated
                case displayOrderUpdated
                case displayUploadedPhoto(photoUrl: String)
                case showErrorAlert(title: String, message: String)
                
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
    var urls: [String]
    var videoUrls: [String]
    
    var representation: [String: Any] {
        var rep: [String: Any]  = ["title": title]
        rep["description"] = description
        rep["isFree"] = isFree
        rep["counterOffer"] = counterOffer
        rep["tags"] = tags
        rep["urls"] = urls
        rep["videoUrls"] = videoUrls
        
        return rep
    }
}
