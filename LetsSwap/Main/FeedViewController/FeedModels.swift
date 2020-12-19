//
//  FeedModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Feed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getFeed
        case getFilteredFeed(tags: Set<FeedTag>)
      }
    }
    struct Response {
      enum ResponseType {
        case presentFeed(result: Result<FeedResponse, FeedError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFeed(feedViewModel: FeedViewModel)
        case displayError(error: Error)
        case displayEmptyFeed
      }
    }
  }
  
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel, Hashable {
        
        var orderId: Int
        
        var title: String
        var description: String
        var counterOffer: String
        var photo: URL?
        var isFavourite: Bool
        var isFree: Bool
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(orderId)
        }
        
        static func == (lhs: FeedViewModel.Cell, rhs: FeedViewModel.Cell) -> Bool {
            return lhs.orderId == rhs.orderId
        }
    }
    
    let cells: [Cell]
}

enum FeedTag: String, CaseIterable, Hashable {
    case IT = "IT, интернет"
    case householdServices = "Бытовые услуги"
    case art = "Исскуство"
    case beautyHealth = "Красота, здоровье"
    case fashion = "Мода"
    case education = "Обучение"
    case handicraft = "Рукоделие"
    case celebrations = "Праздники,мероприятия"
    case advertising = "Реклама"
    case workWithChildren = "Работа с детьми"
    case repairOfEquipment = "Ремонт техники"
    case advertAgain = "Опять реклама"
    case building = "Строительство"
    case plants = "Сад,растения"
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
