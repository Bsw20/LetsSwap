//
//  FeedWorker.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class FeedService {
    var fetcher: FeedDataFetcher
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String? //Для запроса новой пачки предложений
    
    init() {
        self.fetcher = NetworkDataFetcher()
    }
    
    func getFeed(completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            
            case .success(let feed):
                self.feedResponse = feed
                completion(result)
            case .failure( _):
                completion(result)
            }
        }
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) {
        fetcher.getOrder(orderId: orderId) { [weak self] (result) in
            guard let self = self else { return }
            completion(result)
        }
        
    }
}
