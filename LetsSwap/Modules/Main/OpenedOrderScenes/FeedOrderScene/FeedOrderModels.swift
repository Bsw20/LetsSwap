//
//  FeedOrderModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
enum FeedOrder {
   
    enum Model {
        struct Request {
            enum RequestType {
                case tryToDelete(orderId: Int)
                case changeHidingState(orderId: Int)
                case validateSwap(orderId: Int)
                case reloadWholeData(orderId: Int)
            }
        }
        
        struct Response {
            enum ResponseType {
                case presentDeleting(Result<Void, FeedOrderError>)
                case presentNewHidingState(Result<Bool, FeedOrderError>)
                case presentSwapping(Result<Void, Error>)
                case presentUpdatedData(Result<MyProfileOrderResponse, MyProfileError>)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case displayUpdatedData(model: FeedOrderModel)
                case displayUpdatingDataError
                case displayDeleting
                case displayNewHidingState(newState: Bool)
                case displaySwapping
                case displayError(error: Error)
            }
        }
    }
}

struct FeedOrderModel: OrderRepresentableViewModel {
    
    var orderId: Int
    var title: String
    var description: String
    var counterOffer: String
    var isFree: Bool
    var tags: [FeedTag]
    var photoAttachments: [URL]
    var isHidden: Bool
}

protocol CommentsViewModel {
    var orderId: Int { get }
}
struct CommentsOrderModel: CommentsViewModel {
    var orderId: Int
}

enum FeedOrderType {
    case alienProfileOrder(model: OrderViewModel)
    case mainFeedOrder(model: OrderViewModel)
    case myProfileOrder(model: FeedOrderModel)
    
    func getOrderId() -> Int {
        switch self {
        
        case .alienProfileOrder(model: let model):
            return model.orderId
        case .mainFeedOrder(model: let model):
            return model.orderId
        case .myProfileOrder(model: let model):
            return model.orderId
        }
    }
    
    func getUserId() -> Int? {
        switch self {
        
        case .alienProfileOrder(model: let model):
            return model.userId
        case .mainFeedOrder(model: let model):
            return model.userId
        case .myProfileOrder(model: let model):
            return nil
        }
    }
    
    func isTopViewHidden() -> Bool {
        switch self {
        
        case .alienProfileOrder(model:  _):
            return true
        case .mainFeedOrder(model:  _):
            return false
        case .myProfileOrder(model:  _):
            return true
        }
    }
    
    func getUserModel() -> UserRepresentableViewModel? {
        switch self {
        case .mainFeedOrder(model: let model):
            return model.user
        default:
            return nil
        }
    }
    
    func isSwapButtonHidden() -> Bool {
        switch self {
        
        case .alienProfileOrder(model: _):
            return false
        case .mainFeedOrder(model: _):
            return false
        case .myProfileOrder(model: _):
            return true
        }
    }
    func getNavigationTitle() -> String{
        switch self {
        
        case .alienProfileOrder(model:  _):
            return "Предложение"
        case .mainFeedOrder(model: _):
            return "Предложение"
        case .myProfileOrder(model:  _):
            return "Мое предложение"
        }
    }
    
    func isHidden() -> Bool? {
        switch self {
        
        case .alienProfileOrder(model: let model):
            return nil
        case .mainFeedOrder(model: let model):
            return nil
        case .myProfileOrder(model: let model):
            return model.isHidden
        }
    }
}
