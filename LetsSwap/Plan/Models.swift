//
//  Models.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 09.12.2020.
//

import Foundation
import UIKit

struct User {
    var id: Int?
    var lastname: String
    var firstname: String
    var phoneNumber: PhoneNumber?
    var email: Email?
    var city: String
    var swapsCount: Int
    var raiting: Double
    var photo: Photo
    var posts: [Post]
    var favouritePosts: [FavouritePost]
}
struct Order {
    var orderId: Int?
    var postId: Int
    var userId: Int
    var message: String
    var isAccepted: OrderState
}

enum OrderState {
    case Accepted
    case Finished
    //..
}

struct Post {
    var userId: Int
    var postId: Int? //TODO: check
    var title: String
    var myOffer: String
    var anotherOffer: String
    var isFree: Bool
    var isHiden: Bool
    var tags: [Tag]
}

struct Tag {
    var name: String
}

struct Photo {
    var photoUrl: String
}

struct PhoneNumber {
    var phone: String
}
struct Email {
    var email: String
}

struct FavouritePost {
    var postId: Int
}
