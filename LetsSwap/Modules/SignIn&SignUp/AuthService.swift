//
//  AuthService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.01.2021.
//

import Foundation
import UIKit
import Alamofire

struct AuthService {
    
    private static var sendSmsUrl = URL(string: "http://92.63.105.87:3000/smsSend")
    private static var signUpUrl = URL(string: "http://92.63.105.87:3000/register")
    
    func sendSms(login: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print(#function)
        guard let url = AuthService.sendSmsUrl else {
            completion(.failure(AuthError.APIUrlError))
            return
        }

        let userData: [String: Any] = ["login": login]
        print(login)
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json"
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
                        print(data)
                        if data["message"] == "success" {
                            completion(.success(Void()))
                            return
                        }
                    }
                    completion(.failure(AuthError.serverError))

                case .failure(let error):
                    print(error)
                    #warning("figure out with error types")

            }
        }
    }
    
    func signUp(signUpModel: SignUpViewModel, completion: @escaping (Result<Void, AuthError>) -> Void) {
        print(#function)
        print(signUpModel.representation)
        guard let url = AuthService.signUpUrl else {
            completion(.failure(AuthError.APIUrlError))
            return
        }
        
        guard let _ = signUpModel.smsCode else {
            fatalError("Нет смс кода")
        }
        
        let userData = signUpModel.representation
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json"
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
                        print(data)
                        if let token = data["token"] {
                            completion(.success(Void()))
                            return
                        }
                    }
                    completion(.failure(AuthError.serverError))
                case .failure(let error):
                    print(error)
                    #warning("figure out with error types")
                    completion(.failure(AuthError.serverError))
            }
        }
    }
}
