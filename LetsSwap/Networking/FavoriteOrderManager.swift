//
//  FavoriteOrderManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 12.02.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

struct FavoriteOrderManager {
    private var token = APIManager.getToken()
    public static var shared = FavoriteOrderManager()
    
    func changeState(orderID: Int, isFavorite: Bool, completion: @escaping(Result<Bool, Error>) -> Void) {
        if isFavorite {
            request(isFavorite: isFavorite, stringUrl: "http://92.63.105.87:3000/order/favorite/deleteFavorite/\(orderID)", completion: completion)
            return
        }
        request(isFavorite: isFavorite, stringUrl: "http://92.63.105.87:3000/order/favorite/addFavorite/\(orderID)", completion: completion)
    }
    
    private func request(isFavorite: Bool, stringUrl: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        guard let url = URL(string: stringUrl) else {
            SwiftyBeaver.error(String.incorrectUrl(url: stringUrl))
            completion(.failure(NSError()))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : token
                ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(!isFavorite))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(NSError()))
                }
            })
        
        
    }
    
    private func makeUnfavorite(orderID: Int, completion: @escaping(Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/order/favorite/deleteFavorite/\(orderID)") else {
            completion(.failure(NSError()))
            return
        }
    }
}
