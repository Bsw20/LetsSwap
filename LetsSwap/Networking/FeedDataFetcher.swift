//
//  DataFetcher.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

protocol FeedDataFetcher {
    func getFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void)
    func getAlienProfile(userId: Int, completion: @escaping (Result<AlienProfile.FullModel.Response, AlienProfileError>) -> Void)
    func getFiltredFeed(model:FiltredFeedModel, nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
    func getFavoriteOrdersFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
}


struct NetworkDataFetcher: FeedDataFetcher {
    
    public static var shared = NetworkDataFetcher()
    private var getFeedUrl = URL(string: "http://178.154.210.140:3030/security/order/feed/getFeed")
    private var getFiltredFeedUrl = URL(string: "http://178.154.210.140:3030/security/order/search")
    private var getFavoriteOrdersFeedUrl = URL(string: "http://178.154.210.140:3030/security/order/favorite/getFavorite")
    func getFavoriteOrdersFeed(nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        guard let url = getFavoriteOrdersFeedUrl else {
            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(FeedResponse.self, from: data)
//                        let model = data as? [String: Any]
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }

    
    func getFiltredFeed(model:FiltredFeedModel, nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        guard let url = getFiltredFeedUrl else {
            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        let userData = model.representation
        AF.request(url, method: .post,
                   parameters: userData, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(FeedResponse.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })

    }
    
    

    func getFeed(nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
//        completion(.success(FeedResponse(items: NetworkDataFetcher.feedItems, nextFrom: "nextBatch")))
        guard let url = getFeedUrl else {
            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(FeedResponse.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) {
        guard let url = URL(string: "http://178.154.210.140:3030/security/order/feed/getOrderFeed/\(orderId)")  else {
            completion(.failure(OrderError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(OrderResponse.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(OrderError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(OrderError.serverError))
                    #warning("figure out with error types")
                }
            })
    }

    func chooseOrder(chooseOrderModel: ChooseOrderModel, completion: @escaping (Result<Void, ChooseOrderError>) -> Void) {
        completion(.success(Void()))
//        completion(.failure(ChooseOrderError.orderAlreadyChoose))
    }
    
    typealias FullProfileResponse = AlienProfile.FullModel.Response
    func getAlienProfile(userId: Int, completion: @escaping (Result<FullProfileResponse, AlienProfileError>) -> Void) {
        print(#function)
        
        guard let url = URL(string: "http://178.154.210.140:3030/security/user/getProfile") else {
            completion(.failure(AlienProfileError.unknownError))
            return
        }
        print(url)
        print("headers")
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        let data = ["id" : userId]
        AF.request(url, method: .get, parameters: data, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(AlienProfile.FullModel.Wrapper.self, from: data)
                        completion(.success(.init(model: .success(model))))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(AlienProfileError.serverError))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(AlienProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
        
    }
    
}

