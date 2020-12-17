//
//  FeedPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
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
                let cells = feed.items.map { feedItem in
                    cellViewModel(from: feedItem)
                }
                let feedViewModel = FeedViewModel.init(cells: cells)
                viewController?.displayData(viewModel: .displayFeed(feedViewModel: feedViewModel))
            case .failure(let feedError):
                switch feedError {
                
                case .emptyFeedError:
                    viewController?.displayData(viewModel: .displayEmptyFeed)
                default:
                    viewController?.displayData(viewModel: .displayError(error: feedError))
                }
            }
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        var url: URL? = nil
        if let photo = feedItem.photo, let photoURL = URL(string: photo.url) {
            url = photoURL
        }
        return FeedViewModel.Cell.init(title: feedItem.title,
                                       description: feedItem.description,
                                       counterOffer: feedItem.counterOffer,
                                       photo: url,
                                       isFavourite: feedItem.isFavourite,
                                       isFree: feedItem.isFree)
    }
}
