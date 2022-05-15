//
//  AuthService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.01.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

struct AuthService {
    public static var shared = AuthService()
    
    private static var sendSmsUrl = URL(string: "http://178.154.210.140:3030/smsSend")
    private static var signUpUrl = URL(string: "http://178.154.210.140:3030/register")
    private static var signInUrl = URL(string: "http://178.154.210.140:3030/login")
    
    
    func sendAPNSToken(token: String, completion:@escaping (Result<Void, Error>) -> Void ) {
        let url = URL(string: "http://178.154.210.140:3030/security/user/setToken")!
        
        
        let userData: [String: Any] = ["token": token]
        print("tok \(APIManager.getToken())")
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
                print(response.description)
                switch response.result {

                case .success(let data):
                    completion(.success(Void()))

                case .failure(let error):
                    print(error.errorDescription)
                    completion(.failure(AuthError.serverError))

            }
        }
    }
    
    func sendSms(login: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("......")
        print(#function)
        guard let url = AuthService.sendSmsUrl else {
            completion(.failure(AuthError.APIUrlError))
            return
        }

        let userData: [String: Any] = ["login": login]
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
                        if data["message"] == "success" {
                            print("успешно")
                            completion(.success(Void()))
                            return
                        }
                    }
                    SwiftyBeaver.error("Can't decode data")
                    completion(.failure(AuthError.serverError))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(AuthError.serverError))
                    #warning("figure out with error types")

            }
        }
    }
    
    func signUp(signUpModel: SignUpViewModel, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let url = AuthService.signUpUrl else {
            completion(.failure(AuthError.APIUrlError))
            return
        }
        
        guard let _ = signUpModel.smsCode else {
            fatalError("Нет смс кода")
        }
        print(#function)
        
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
                        if let token = data["token"] {
                            APIManager.setToken(token: token)
                            print(APIManager.getToken())
                            completion(.success(Void()))
                            return
                        }
                    }
                    SwiftyBeaver.error("Can't decode data")
                    completion(.failure(AuthError.serverError))
                case .failure(let error):
                    #warning("figure out with error types")
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(AuthError.serverError))
            }
        }
    }
    
    func signIn(signInModel: SignInViewModel, completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let url = AuthService.signInUrl else {
            completion(.failure(AuthError.APIUrlError))
            return
        }
        
        guard let _ = signInModel.smsCode else {
            fatalError("Нет смс кода")
        }
        print(#function)
        
        let userData = signInModel.representation
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
                        if let token = data["token"] {
                            APIManager.setToken(token: token)
                            print(APIManager.getToken())
                            completion(.success(Void()))
                            return
                        }
                    }
                    SwiftyBeaver.error("Can't decode data")
                    completion(.failure(AuthError.serverError))
                case .failure(let error):
                    #warning("figure out with error types")
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(AuthError.serverError))
            }
        }
    }
}
