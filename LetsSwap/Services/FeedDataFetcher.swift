//
//  DataFetcher.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
import Alamofire

protocol FeedDataFetcher {
    func getFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void)
    func getAlienProfile(completion: @escaping (Result<ProfileResponse, AlienProfileError>) -> Void)
    func getFiltredFeed(model:FiltredFeedModel, nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
    func getFavoriteOrdersFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
}


struct NetworkDataFetcher: FeedDataFetcher {
    public static var shared = NetworkDataFetcher()
    private var getFeedUrl = URL(string: "http://92.63.105.87:3000/order/feed/getFeed")
    private var getFiltredFeedUrl = URL(string: "http://92.63.105.87:3000/order/search")
    private var getFavoriteOrdersFeedUrl = URL(string: "http://92.63.105.87:3000/order/favorite/getFavorite")
    func getFavoriteOrdersFeed(nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        guard let url = getFavoriteOrdersFeedUrl else {
            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
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
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
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
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
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
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
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
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
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
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/order/feed/getOrderFeed/\(orderId)")  else {
            completion(.failure(OrderError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
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
                        completion(.failure(OrderError.incorrectDataModel))
                    }

                case .failure(let error):
                    completion(.failure(OrderError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
//    private var orderWithId1 = OrderResponse.init(user: PostedUser(userId: 123, photo: "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album", name: "Настя", lastName: "Якимова", city: "Санкт-Петербург",
//                order: Order.init(orderId: 1, tags: ["IT, интернет", "Бытовые услуги", "Реклама", "Установка техники"], title: "Делаю необычные тату", description: "Ищу моделей для своего портфолио в инстаграм. Можете посмтреть уже готовые работы @okxytatt", counterOffer: "Я бы хотела научиться читать рэп или взять пару уроков по битбоку.", isFree: false, photoAttachments: [ "https://sun1-30.userapi.com/impf/PXyjEBA29GMv-BrShS9lAwJftKcl1L7zoKwtRw/GmuWSQIRiFE.jpg?size=453x604&quality=96&sign=89fc7b9a09c8cc4df7257e8109ca8255&c_uniq_tag=JpkLKplffEJgiWSHXoOgh7GSreoWWk0y_mB2iAXs1O8&type=album",  "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album"
//                ]))
    
    
    func chooseOrder(chooseOrderModel: ChooseOrderModel, completion: @escaping (Result<Void, ChooseOrderError>) -> Void) {
        completion(.success(Void()))
//        completion(.failure(ChooseOrderError.orderAlreadyChoose))
    }
    
    func getAlienProfile(completion: @escaping (Result<ProfileResponse, AlienProfileError>) -> Void) {
//        completion(.success(FeedResponse(items: feedItems, nextFrom: "nextBatch")))
        completion(.success(ProfileResponse.init(userId: 12345,
                                                 userDescription: ProfileDescription.init(userPhoto: Photo(url: "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album"), swapsCount: 67, raiting: 4.8, name: "Ярослав", lastName: "Карпунькин", cityName: "г.Москва"),
//                                                 feedResponse: FeedResponse(items: NetworkDataFetcher.feedItems, nextFrom: "nextBatchFrom")
                                                 feedResponse: FeedResponse(items: [], nextFrom: "nextBatchFrom")
        )))
    }
    
}
