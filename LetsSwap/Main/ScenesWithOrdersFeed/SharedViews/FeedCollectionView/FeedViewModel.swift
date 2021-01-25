//
//  FeedViewModel.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

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

