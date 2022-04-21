//
//  OrderResponse.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//

import Foundation
import UIKit

struct OrderResponse: Decodable {
    var user: PostedUser
    var order: Order
}

struct PostedUser: Decodable {
    let userId: Int
    let photo: String?
    let name: String
    let lastName: String
    let city: String
}

struct Order: Decodable {
    let orderId: Int
    var tags: [String] //Если их нет, будет пустой массив
    var title: String
    var description: String

    var counterOffer: String
    var isFree: Bool
    var photoAttachments: [String]
    var videoAttachments: [String]
}
