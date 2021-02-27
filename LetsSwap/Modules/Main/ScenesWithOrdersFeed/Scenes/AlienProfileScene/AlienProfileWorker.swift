//
//  AlienProfileWorker.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

class AlienProfileService {
    typealias FullProfileRequest = AlienProfile.FullModel.Request
    typealias FullProfileResponse = AlienProfile.FullModel.Response
    var fetcher: FeedDataFetcher
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String? //Для запроса новой пачки предложений
    
    
    init() {
        self.fetcher = NetworkDataFetcher()
    }
    
    func getFullModel(requestModel: FullProfileRequest, completion: @escaping (Result<FullProfileResponse, AlienProfileError>) -> Void) {
        fetcher.getAlienProfile(userId: requestModel.userId) { [weak self] (result) in
            guard let self = self else { return }
            completion(result)
        }
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) {
        fetcher.getOrder(orderId: orderId) { [weak self] (result) in
            guard let self = self else { return }
            completion(result)
        }
        
    }
}
