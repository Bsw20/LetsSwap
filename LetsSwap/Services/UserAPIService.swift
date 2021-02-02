//
//  UserAPIService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.01.2021.
//

import Foundation
import UIKit
import Alamofire


protocol MyProfileFetcher {
    func getMyProfile(completion: @escaping (Result<MyProfileViewModel, MyProfileError>) -> Void)
}

protocol EditProfileFetcher {
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void)
}

protocol FullOrderFetcher {
    func createOrder(model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>)-> Void)
}

struct UserAPIService: MyProfileFetcher, EditProfileFetcher, FullOrderFetcher {
    public static let shared = UserAPIService()
    
    private enum RequestUrl {
        case getMyProfile
        case createOrder
        
        func getUrl() -> URL? {
            switch self {
            
            case .getMyProfile:
                return URL(string: "http://92.63.105.87:3000/user/getProfile")
            case .createOrder:
                return URL(string: "http://92.63.105.87:3000/order/makeNew")
            }
        }
    }
    
    public func getMyProfile(completion: @escaping (Result<MyProfileViewModel, MyProfileError>) -> Void) {
        guard let url = RequestUrl.getMyProfile.getUrl() else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(MyProfileViewModel.self, from: data)
                        print(model)
                        completion(.success(model))
                    } catch {
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
//            .responseJSON { (response) in
//                switch response.result {
//                
//                case .success(let data):
//                    do {
//                        let root = try JSONDecoder().decode(MyProfileViewModel.self, from: response.data)
//                    } catch {
//                    
//                    }
//
//                case .failure(let error):
//                    print(error)
//                    completion(.failure(MyProfileError.serverError))
//                    #warning("figure out with error types")
//                }
//            }
    }
    
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        #warning("TODO")
        completion(.success(Void()))
    }
    
    func createOrder(model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        print(#function)
        guard let url = RequestUrl.createOrder.getUrl() else {
            completion(.failure(MyProfileError.APIUrlError))
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

                case .success(let data):
                    if let data = data as? [String:String] {
                        print(data)
                        if data["message"] == "success" {
                            completion(.success(Void()))
                            return
                        }
                    }
                    completion(.failure(MyProfileError.serverError))

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")

            }
        }
    }
    
}
