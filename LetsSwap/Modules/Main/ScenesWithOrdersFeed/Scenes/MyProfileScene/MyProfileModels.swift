//
//  MyProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
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

struct MyProfileViewModel: Decodable {
    struct PersonInfo: Decodable, ProfileTopViewModel, MyProfileHeaderViewModel {
        var profileImage: String?
        var name: String
        var lastname: String
        var cityName: String
        var swapsCount: Int
        var raiting: Double
    }
    
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
                return lhs.orderId == rhs.orderId
            }
        }
        
        let cells: [Cell]
    }
    
    var personInfo: PersonInfo
    var feedInfo: FeedModel
}

struct MyProfileOrderResponse {
    var orderId: Int
    var title: String
    var description: String
    var counterOffer: String
    var isFree: Bool
    var tags: [String]
    var photoAttachments: [String]
    var isHidden: Bool
}
