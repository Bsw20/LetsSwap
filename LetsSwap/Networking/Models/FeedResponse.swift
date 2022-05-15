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

class FeedItem: Object, Decodable {
    dynamic var orderId = 0
    dynamic var title = ""
    dynamic var desc = ""
    dynamic var counterOffer = ""
    dynamic var isFavorite = false
    dynamic var isFree = false
    dynamic var photo = ""
}


