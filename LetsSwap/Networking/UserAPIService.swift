//
//  UserAPIService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.01.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyBeaver

//MARK: - Protocols
protocol MyProfileFetcher {
    func getMyProfile(completion: @escaping (Result<MyProfileResponseModel, MyProfileError>) -> Void)
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void)
    func getFullProfileModel(completion: @escaping (Result<EditProfileViewModel, MyProfileError>) -> Void)
}

protocol EditProfileFetcher {
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void)
}

protocol FullOrderFetcher {
    func createOrder(model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>)-> Void)
    func uploadImage(image: UIImage, completion: @escaping (Result<StringURL, MyProfileError>)-> Void)
    func updateOrder(orderId: Int, model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>)-> Void)
}

protocol FeedOrderFetcher {
    func deleteOrder(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void)
    func changeHidingState(orderId: Int, completion: @escaping (Result<Bool, FeedOrderError>) -> Void
    )
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void)
}

struct UserAPIService:  EditProfileFetcher {
    public static let shared = UserAPIService()
    
    private enum RequestUrl {
        case getMyProfile
        case createOrder
        case uploadImage
        case updateUserInfo
        case getProfileForEditing
        func getUrl() -> URL? {
            switch self {
            
            case .getMyProfile:
                return URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/user/getProfile")
            case .createOrder:
                return URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/order/makeNew")
            case .uploadImage:
                return URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/image/upload")
            case .updateUserInfo:
                return URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/user/update")
            case .getProfileForEditing:
                return URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/user/getProfileEditing")
            }
        }
    }
    
    
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        guard let url = RequestUrl.updateUserInfo.getUrl() else {
            SwiftyBeaver.error(String.incorrectUrl(url: RequestUrl.updateUserInfo.getUrl()))
            completion(.failure(MyProfileError.incorrectDataModel))
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
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")

            }
        }
        
    }
    
    func downloadImage(url: String, completion:@escaping (Result<Data, Error>) -> Void) {
        let imageURL = url
        let headers: HTTPHeaders = [
            "Authorization" : APIManager.getToken()
                ]
        AF.request(imageURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch response.result {
                
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(error))

                }
            }
    }
}

//MARK: - MyProfileFetcher
extension UserAPIService: MyProfileFetcher {
    func getFullProfileModel(completion: @escaping (Result<EditProfileViewModel, MyProfileError>) -> Void) {
        guard let url = RequestUrl.getProfileForEditing.getUrl() else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(EditProfileViewModel.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(String.cantDecodeDataString(error: error))
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void) {
        
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/order/\(orderId)") else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(MyProfileOrderResponse.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(String.cantDecodeDataString(error: error))
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })

    }
    
        
    public func getMyProfile(completion: @escaping (Result<MyProfileResponseModel, MyProfileError>) -> Void) {
        guard let url = RequestUrl.getMyProfile.getUrl() else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(MyProfileResponseModel.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        SwiftyBeaver.error(String.cantDecodeDataString(error: error))
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
}

//MARK: - FullOrderFetcher
extension UserAPIService: FullOrderFetcher {
    func updateOrder(orderId: Int, model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/order/update/\(orderId)") else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        let userData = model.representation
        print(userData)
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .post,
                   parameters: userData, encoding: JSONEncoding.default, headers: headers
                   )
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        completion(.success(Void()))
                    } catch(let error){
                        SwiftyBeaver.error(String.cantDecodeDataString(error: error))
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func createOrder(model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        guard let url = RequestUrl.createOrder.getUrl() else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let userData: [String: Any] = model.representation
        print(userData)
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
                        if data["message"] == "success" {
                            completion(.success(Void()))
                            return
                        }
                    }
                    SwiftyBeaver.error(String.cantDecodeDataString(error: "Incorrect json"))
                    completion(.failure(MyProfileError.serverError))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")

            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Result<StringURL, MyProfileError>) -> Void) {
        guard let fileData = image.jpegData(compressionQuality: 0.9) else {
           return
         }
        guard let url = RequestUrl.uploadImage.getUrl() else  {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization" : APIManager.getToken()
                ]
        
        FilesService.shared.uploadFile(fileData: fileData) {result in
            switch result {
                
            case .success(let model):
                completion(.success(model.url?.absoluteString))
            case .failure(let error):
                completion(.failure(.APIUrlError))
            }
        }
    }
}

//MARK: - FeedOrderFetcher
extension UserAPIService: FeedOrderFetcher {
    func deleteOrder(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/order/delete/\(orderId)") else {
            completion(.failure(FeedOrderError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    completion(.success(Void()))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedOrderError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func changeHidingState(orderId: Int, completion: @escaping (Result<Bool, FeedOrderError>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/order/changeHidden/\(orderId)") else {
            completion(.failure(FeedOrderError.APIUrlError))
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
                    if let json = data as? [String : Any], let newState = json["newState"] as? Bool {
                        completion(.success(newState))
                        return
                    }
                    SwiftyBeaver.error(String.incorrectJSON(data))
                    completion(.failure(FeedOrderError.serverError))

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedOrderError.serverError))
                    #warning("figure out with error types")
                }
            })
        
    }
    
    
    
}
