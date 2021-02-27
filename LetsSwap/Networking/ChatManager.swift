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
    public static var shared = ChatManager()
    func getAllMessages(chatId: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: APIManager.serverAddress + "/chat/getChatMessages/\(chatId)") else {
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
}
