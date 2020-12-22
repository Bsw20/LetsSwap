//
//  Models.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 09.12.2020.
//

import Foundation
import UIKit

private struct UserPlan {
    var id: Int?
    var lastname: String
    var firstname: String
    var phoneNumber: PhoneNumber?
    var email: Email?
    var city: String
    var swapsCount: Int
    var raiting: Double
    var photo: PhotoPlan
    var posts: [PostPlan]
    var favouritePosts: [FavouritePost]
}
private struct OrderPlan {
    var orderId: Int?
    var postId: Int
    var userId: Int
    var message: String
    var isAccepted: OrderState
}

private enum OrderState {
    case Accepted
    case Finished
    //..
}

private struct PostPlan {
    var userId: Int
    var postId: Int? //TODO: check
    var title: String
    var myOffer: String
    var anotherOffer: String
    var isFree: Bool
    var isHiden: Bool
    var tags: [TagPlan]
}

private struct TagPlan {
    var name: String
}

private struct PhotoPlan {
    var photoUrl: String
}

private struct PhoneNumber {
    var phone: String
}
private struct Email {
    var email: String
}

private struct FavouritePost {
    var postId: Int
}
