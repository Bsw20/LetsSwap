//
//  ChatManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 25.02.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

protocol ConversationsManager {
    func getAllConversations(completion: @escaping (Result<Any, Error>) -> Void)
    func getChatData(chatId: Int, completion: @escaping (Result<Any, Error>) -> Void)
}

struct ChatManager: ConversationsManager {
    public static var shared = ChatManager()
    func getAllMessages(chatId: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: APIManager.serverAddress + "/chatModule/chat/getChatMessages") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["chatId" : chatId]
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        print(APIManager.getToken())
        AF.request(url, method: .post,parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    if let model = data as? [String: Any] {
                        SwiftyBeaver.info(#function)
                        completion(.success(model))
                        return
                    }
                    SwiftyBeaver.error("Can't parse data Error")
                    completion(.failure(FeedError.incorrectDataModel))
                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                }
            })
    }
    
    func getAllConversations(completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/chatModule/chat/getAll") else {
            completion(.failure(NSError()))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func getChatData(chatId: Int, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/user/getUserInfoForChat") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["chatId" : chatId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        print(APIManager.getToken())
        AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                        completion(.success(data))
                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func setRating(userId: Int, rating: Int, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/setRating") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["userId" : userId, "rating" : rating]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        print(APIManager.getToken())
        AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func changeDone(chatId: Int, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/finishChange") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["chatId" : chatId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        print(APIManager.getToken())
        AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func deleteChat(chatId: Int, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/user/removeChat") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["chatId" : chatId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        print(APIManager.getToken())
        AF.request(url, method: .post, parameters: userData, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
}
