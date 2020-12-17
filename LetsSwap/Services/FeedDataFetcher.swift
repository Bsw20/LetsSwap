//
//  DataFetcher.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

protocol FeedDataFetcher {
    func getFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
}

struct NetworkDataFetcher: FeedDataFetcher {
    func getFeed(nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        //TODO:
    }
    
    
}
