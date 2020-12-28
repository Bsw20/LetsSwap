//
//  AlienProfileWorker.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class AlienProfileService {
    var fetcher: FeedDataFetcher
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String? //Для запроса новой пачки предложений
    
    init() {
        self.fetcher = NetworkDataFetcher()
    }
    
    func getProfile(completion: @escaping (Result<ProfileResponse, AlienProfileError>) -> Void) {
        fetcher.getAlienProfile { [weak self](result) in
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
}
