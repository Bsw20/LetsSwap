//
//  FeedResponse.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var nextFrom: String?
}

struct FeedItem: Decodable {
    let orderId: Int
    let title: String
    let description: String
    let counterOffer: String
    #warning("Если использовать в MyProfileVC, то сделать его опциональным")
    #warning("IsHidden ")
    let isFavourite: Bool
    let isFree: Bool
    let date: Double
    let photo: Photo?
    //photo: String?
    //isHidden: 
}


