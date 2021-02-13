//
//  SwapsManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 14.02.2021.
//

import Foundation
import UIKit
import Alamofire

protocol SwapsFetcher {
    func validateSwap(orderId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func makeSwap(model: MakeSwapModel, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    //MARK: - Funcs
    func validateSwap(orderId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/change/canMakeChange/\(orderId)") else {
            completion(.failure(NSError()))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch response.result {
                
                case .success(_):
                    print("Swap validate success")
                    completion(.success(Void()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func makeSwap(model: MakeSwapModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/change/addChange") else {
            completion(.failure(NSError()))
            return
        }
        let userData: [String: Any] = model.representation
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .post,
                   parameters: userData,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {

                case .success(_):
                    print("Make swap success")
                    completion(.success(Void()))

                case .failure(let error):
                    completion(.failure(error))
                    #warning("figure out with error types")

            }
        }
    }
    
}
