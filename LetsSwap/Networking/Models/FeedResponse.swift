//
//  FeedResponse.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
import RealmSwift

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var nextFrom: String?
    var city: String?
}

struct FeedItem: Decodable {
    let orderId: Int
    let title: String
    let description: String
    let counterOffer: String
    let isFavorite: Bool
    let isFree: Bool
    let photo: String?
}


