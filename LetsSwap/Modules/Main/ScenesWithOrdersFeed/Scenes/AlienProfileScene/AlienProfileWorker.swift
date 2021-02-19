//
//  AlienProfileWorker.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

class AlienProfileService {
    var fetcher: FeedDataFetcher
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String? //Для запроса новой пачки предложений
    
    init() {
        self.fetcher = NetworkDataFetcher()
    }
    
    func getProfile(userId: Int, completion: @escaping (Result<ProfileResponse, AlienProfileError>) -> Void) {
        fetcher.getAlienProfile(userId: userId) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            
            case .success(let profile):
                self.feedResponse = profile.feedResponse
                self.newFromInProcess = profile.feedResponse.nextFrom
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
