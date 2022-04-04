//
//  FeedModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

enum Feed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getFeed
        case getFilteredFeed(model: FiltredFeedModel)
        case getOrder(orderId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentFeed(result: Result<FeedResponse, FeedError>)
        case presentOrder(result: Result<OrderResponse, OrderError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFeed(feedViewModel: FeedViewModel)
        case displayOrder(orderViewModel: OrderViewModel)
        case displayError(error: Error)
        case displayEmptyFeed
      }
    }
  }
  
}

struct FiltredFeedModel {
    var selectedTags: Set<FeedTag>
    var text: String
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["tags": Array(selectedTags).map{$0.rawValue}]
        rep["searchString"] = text
        return rep
    }
}

struct OrderViewModel: FeedOrderRepresentableModel {
    
    
    struct Order: OrderRepresentableViewModel {
        var title: String
        var description: String
        var counterOffer: String
        var isFree: Bool
        var tags: [FeedTag]
        var photoAttachments: [URL]
    }
    struct User: UserRepresentableViewModel, OrderTitleViewModel {
        var userName: String
        var userLastName: String
        var userCity: String
        var userPhoto: URL?
    }
    var order: OrderRepresentableViewModel
    var user: UserRepresentableViewModel
    
    var orderId: Int
    var userId: Int
    func getOrderTitleViewModel() -> OrderTitleViewModel?{
        return user as? OrderTitleViewModel
    }
}

enum FeedTag: String, CaseIterable, Hashable {
    case IT = "IT, интернет"
    case householdServices = "Бытовые услуги"
    case art = "Исскуство"
    case beautyHealth = "Красота, здоровье"
    case fashion = "Мода"
    case education = "Обучение"
    case handicraft = "Рукоделие"
    case celebrations = "Праздники, мероприятия"
    case advertising = "Реклама"
    case workWithChildren = "Работа с детьми"
    case repairOfEquipment = "Ремонт техники"
    case advertAgain = "Опять реклама"
    case building = "Строительство"
    case plants = "Сад, растения"
    case cleaning = "Уборка"
    case equipmentSetup = "Установка техники"
    case photography = "Фотография"
    case petCare = "Уход за животными"
    case videoShooting = "Видеосъемка"
    case design = "Дизайн"
    case outOfBounds = "Ни в какие рамки"
    
    static func ==(lhs: FeedTag, rhs: FeedTag) -> Bool {
        return lhs.rawValue == rhs.rawValue
     }
}
