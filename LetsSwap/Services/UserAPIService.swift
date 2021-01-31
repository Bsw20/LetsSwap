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

struct UserAPIService: MyProfileFetcher {
    public static let shared = UserAPIService()
    
    private enum RequestUrl {
        case getMyProfile
        
        func getUrl() -> URL? {
            switch self {
            
            case .getMyProfile:
                return URL(string: "http://92.63.105.87:3000/user/getProfile")
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
}
