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

struct ChatManager {
    func getAllMessages(chatId: Int) {
        guard let url = URL(string: APIManager.serverAddress + "/chat/getChatMessages") else {
//            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        let data = ["chatId" : chatId]
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
//                        let model = try JSONDecoder().decode(FeedResponse.self, from: data)
                        print(data as? [String: Any])
//                        let model = data as? [String: Any]
//                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(error.localizedDescription)
//                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
//                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
}
