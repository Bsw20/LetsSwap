//
//  MyProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

enum MyProfile {
   
    enum Model {
        struct Request {
            enum RequestType {
                case getWholeProfile
                case getOrder(orderId: Int)
                case getFullProfileInfo
            }
        }
        struct Response {
            enum ResponseType {
                case presentWholeProfile(result: Result<MyProfileViewModel, MyProfileError>)
                case presentOrder(result: Result<MyProfileOrderResponse, MyProfileError>)
                case presentFullProfileInfo(result: Result<EditProfileViewModel, MyProfileError>)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayWholeProfile(myProfileViewModel: MyProfileViewModel)
                case displayOrder(orderModel: FeedOrderModel)
                case displayError(error: Error)
                case displayFullProfileInfo(profileInfo: EditProfileViewModel)
            }
        }
    }
}

struct MyProfileResponseModel: Decodable {
    struct PersonInfo: Decodable {
        var profileImage: String?
        var name: String
        var lastname: String
        var cityName: String
        var swapsCount: Int
        var rating: Double
    }
    var chatId: Int?
    struct Cell: Decodable {
        
        var orderId: Int
        
        var title: String
        var description: String
        var counterOffer: String
        var photo: String?
        var isFree: Bool
        var isHidden: Bool
    }
    
    var personInfo: PersonInfo
    var feedInfo: [Cell]
}

struct MyProfileViewModel: Decodable {
    struct PersonInfo: Decodable, ProfileTopViewModel, MyProfileHeaderViewModel {
        var profileImage: String?
        var name: String
        var lastname: String
        var cityName: String
        var swapsCount: Int
        var rating: Double
    }
    var chatId: Int?
    struct FeedModel: Decodable {
        struct Cell: Hashable, BaseFeedCellViewModel, Decodable {
            
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
                return lhs.orderId == rhs.orderId && lhs.isFree == rhs.isFree
            }
        }
        
        let cells: [Cell]
    }
    
    var personInfo: PersonInfo
    var feedInfo: FeedModel
}

struct MyProfileOrderResponse: Decodable {
    var orderId: Int
    var title: String
    var description: String
    var counterOffer: String
    var isFree: Bool
    var tags: [String]
    var photoAttachments: [String]
    var videoAttachments: [String]
    var isHidden: Bool
}
