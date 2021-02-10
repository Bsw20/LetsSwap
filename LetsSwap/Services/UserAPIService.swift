//
//  UserAPIService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.01.2021.
//

import Foundation
import UIKit
import Alamofire

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
    func makeSwap(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void)
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
                return URL(string: "http://92.63.105.87:3000/user/getProfile")
            case .createOrder:
                return URL(string: "http://92.63.105.87:3000/order/makeNew")
            case .uploadImage:
                return URL(string: "http://92.63.105.87:3000/image/upload")
            case .updateUserInfo:
                return URL(string: "http://92.63.105.87:3000/user/update")
            case .getProfileForEditing:
                return URL(string: "http://92.63.105.87:3000/user/getProfileEditing")
            }
        }
    }
    
    
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        guard let url = RequestUrl.updateUserInfo.getUrl() else {
            completion(.failure(MyProfileError.incorrectDataModel))
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
                    completion(.success(Void()))

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")

            }
        }
        
    }
    
    func downloadImage(url: String, completion:@escaping (Result<Data, Error>) -> Void) {
        let imageURL = url
        let headers: HTTPHeaders = [
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        print(#function)
        print(url)
        AF.request(imageURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch response.result {
                
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
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
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print("switch next")
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(EditProfileViewModel.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        print("cant decode")
                        print(error)
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void) {
        
        guard let url = URL(string: "http://92.63.105.87:3000/order/\(orderId)") else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print("switch next")
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(MyProfileOrderResponse.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        print("cant decode")
                        print(error)
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    print(error)
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
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print("switch next")
                switch response.result {

                case .success(let data):
                    do {
//                        let data = data as! [String: Any]
                        let model = try JSONDecoder().decode(MyProfileResponseModel.self, from: data)
                        completion(.success(model))
                    } catch(let error){
                        print("cant decode")
                        print(error)
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
}

//MARK: - FullOrderFetcher
extension UserAPIService: FullOrderFetcher {
    func updateOrder(orderId: Int, model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/order/update/\(orderId)") else {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        let userData = model.representation
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .post,
                   parameters: userData, encoding: JSONEncoding.default, headers: headers
                   )
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print("switch next")
                switch response.result {

                case .success(let data):
                    do {
                        completion(.success(Void()))
                    } catch(let error){
                        print("cant decode")
                        print(error)
                        completion(.failure(MyProfileError.incorrectDataModel))
                    }

                case .failure(let error):
                    print(error)
                    completion(.failure(MyProfileError.serverError))
                    #warning("figure out with error types")
                }
            })
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
    
    func uploadImage(image: UIImage, completion: @escaping (Result<StringURL, MyProfileError>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
           return
         }
        guard let url = RequestUrl.uploadImage.getUrl() else  {
            completion(.failure(MyProfileError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        AF.upload(multipartFormData: { (multiPart) in
//            multiPart.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
            multiPart.append(data, withName: "fileData", fileName: "image.png", mimeType: "image/jpeg")
        }, to: url, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { (result) in
            #warning("RECODE")
            switch result.result {
            
            case .success(let data):
                print(url)
                if let data = data as? [String:String], let dataURL = data["url"] {
                    print(data)
                    completion(.success(dataURL))
                    return
                }
                completion(.failure(MyProfileError.APIUrlError))
            case .failure(let error):
                print(error)
                completion(.failure(MyProfileError.APIUrlError))
            }

        }

//         AF.upload(multipartFormData: { (form) in
//           form.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
//         }, to: "https://yourawesomebackend.com", encodingCompletion: { result in
//           switch result {
//           case .success(let upload, _, _):
//             upload.responseString { response in
//               print(response.value)
//             }
//           case .failure(let encodingError):
//             print(encodingError)
//           }
//         })
    }

}

//MARK: - FeedOrderFetcher
extension UserAPIService: FeedOrderFetcher {
    func deleteOrder(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void) {
        print(#function)
        guard let url = URL(string: "http://92.63.105.87:3000/order/delete/\(orderId)") else {
            completion(.failure(FeedOrderError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                print("switch next")
                switch response.result {

                case .success(let data):
                    completion(.success(Void()))

                case .failure(let error):
                    print(error)
                    completion(.failure(FeedOrderError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
    
    func changeHidingState(orderId: Int, completion: @escaping (Result<Bool, FeedOrderError>) -> Void) {
        print(#function)
        print(#function)
        guard let url = URL(string: "http://92.63.105.87:3000/order/changeHidden/\(orderId)") else {
            completion(.failure(FeedOrderError.APIUrlError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk"
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    print(data)
                    if let json = data as? [String : Any], let newState = json["newState"] as? Bool {
                        completion(.success(newState))
                    }
                    completion(.failure(FeedOrderError.serverError))

                case .failure(let error):
                    print(error)
                    completion(.failure(FeedOrderError.serverError))
                    #warning("figure out with error types")
                }
            })
        
    }
    
    func makeSwap(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void) {
        print(#function)
        completion(.success(Void()))
    }
    
    
}
