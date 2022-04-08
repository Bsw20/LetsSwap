//
//  FeedPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedPresentationLogic {
    func presentData(response: Feed.Model.Response.ResponseType)
}

class FeedPresenter: FeedPresentationLogic {
    weak var viewController: FeedDisplayLogic?
  
    func presentData(response: Feed.Model.Response.ResponseType) {
        switch response {
        
        case .presentFeed(result: let result):
            switch result {
            
            case .success(let feed):
                let feedViewModel = FeedPresenter.getFeedViewModel(feed: feed)
                if let city = feed.city {
                    viewController?.setCity(cityString: city)
                }
                viewController?.displayData(viewModel: .displayFeed(feedViewModel: feedViewModel))
            case .failure(let feedError):
                switch feedError {
                
                case .emptyFeedError:
                    viewController?.displayData(viewModel: .displayEmptyFeed)
                default:
                    viewController?.displayData(viewModel: .displayError(error: feedError))
                }
            }
        case .presentOrder(result: let result):
            switch result {
            
            case .success(let order):
                viewController?.displayData(viewModel: .displayOrder(orderViewModel: FeedPresenter.orderViewModel(from: order)))
            case .failure(let orderError):
                viewController?.displayData(viewModel: .displayError(error: orderError))
            }
        }
    }
    
    static func getFeedViewModel(feed: FeedResponse) -> FeedViewModel {
        let cells = feed.items.map { feedItem in
            cellViewModel(from: feedItem)
        }
        let feedViewModel = FeedViewModel.init(cells: cells)
        return feedViewModel
    }
    
    private static func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        var url: URL? = nil
        if let photo = feedItem.photo, let photoURL = URL(string: photo) {
            url = photoURL
        }
        return FeedViewModel.Cell.init(orderId: feedItem.orderId,
                                       title: feedItem.title,
                                       description: feedItem.description,
                                       counterOffer: feedItem.counterOffer,
                                       photo: url,
                                       isFavourite: feedItem.isFavorite,
                                       isFree: feedItem.isFree)
    }
    static public func orderViewModel(from orderResponse: OrderResponse) -> OrderViewModel {
        let tags = orderResponse.order.tags.compactMap { stringTag in
            FeedTag.init(rawValue: stringTag)
        }
        let attachments = orderResponse.order.photoAttachments.compactMap { photo in
            URL(string: photo)
        }
        
        var userPhoto: URL? = nil
        if let photoStringUrl = orderResponse.user.photo {
            userPhoto = URL(string: photoStringUrl)
        }
        
        let orderViewModel = OrderViewModel.init(order: OrderViewModel.Order.init(title: orderResponse.order.title, description: orderResponse.order.description, counterOffer: orderResponse.order.counterOffer, isFree: orderResponse.order.isFree, tags: tags, photoAttachments: attachments),
                                                 user: OrderViewModel.User.init(userName: orderResponse.user.name, userLastName: orderResponse.user.lastName, userCity: orderResponse.user.city, userPhoto: userPhoto),
                                                 orderId: orderResponse.order.orderId,
                                                 userId: orderResponse.user.userId)
        
        return orderViewModel
    }
}
