//
//  SwapsManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 14.02.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

protocol SwapsFetcher {
    func validateSwap(orderId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func makeSwap(model: MakeSwapModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func confirmSwap(swapId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func refuseSwap(swapId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    
    func createChat(userId: Int, swapId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

struct MakeSwapModel {
    var orderId: Int
    var comment: String
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["orderId": orderId]
        rep["comment"] = comment
        return rep
    }
}

struct SwapsManager: SwapsFetcher{
    //MARK: - Variables
    static var shared = SwapsManager()
    

    func createChat(userId: Int, swapId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/chatModule/chat/create") else {
            SwiftyBeaver.error(String.incorrectUrl(url: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/chatModule/chat/create"))
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = ["userId" : userId, "changeId" : swapId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {

                case .success(_):
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))
                    #warning("figure out with error types")

            }
        }
    }
    
    //MARK: - Funcs
    
    func confirmSwap(swapId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/confirm") else {
            SwiftyBeaver.error(String.incorrectUrl(url: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/confirm"))
            completion(.failure(NSError()))
            return
        }
        print(swapId)
        let userData: [String: Any] = ["changeId" : swapId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {

                case .success(_):
                    print("Confirm swap success")
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))
                    #warning("figure out with error types")

            }
        }
    }
    
    func refuseSwap(swapId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        SwiftyBeaver.info(#function)
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/cancel") else {
            SwiftyBeaver.error(String.incorrectUrl(url: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/cancel"))
            completion(.failure(NSError()))
            return
        }
        print(swapId)
        let userData: [String: Any] = ["changeId" : swapId]
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {

                case .success(_):
                    print("Refuse swap success")
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))
                    #warning("figure out with error types")

            }
        }
    }
    
    func validateSwap(orderId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/canMakeChange/\(orderId)") else {
            SwiftyBeaver.error(String.incorrectUrl(url: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/canMakeChange/\(orderId)"))
            completion(.failure(NSError()))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : APIManager.getToken()
                ]
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch response.result {
                
                case .success(let data):
                    if let data = data as? [String:Bool] {
                        print("change has already added")
                        print(data)
                            //TODO: Вызывать алёрт.
                        completion(.success(false))
                    } else {
                        print("Swap validate success")
                        completion(.success(true))
                    }
                    
                    
                    
                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    func makeSwap(model: MakeSwapModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/addChange") else {
            SwiftyBeaver.error(String.incorrectUrl(url: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/addChange"))
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = model.representation
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {

                case .success(let data):
                    if let data = data as? [String:String] {
                        print(data["message"])
                    }
                    print("Make swap success")
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))
                    #warning("figure out with error types")

            }
        }
    }
    
}
