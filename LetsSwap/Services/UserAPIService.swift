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
    func getMyProfile(completion: @escaping (Result<MyProfileViewModel, MyProfileError>) -> Void)
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void)
    func getFullProfileModel(completion: @escaping (Result<EditProfileViewModel, MyProfileError>) -> Void)
}

protocol EditProfileFetcher {
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void)
}

protocol FullOrderFetcher {
    func createOrder(model: FullOrderViewModel, completion: @escaping (Result<Void, MyProfileError>)-> Void)
    func uploadImage(image: UIImage, completion: @escaping (Result<StringURL, MyProfileError>)-> Void)
}

protocol FeedOrderFetcher {
    func deleteOrder(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void)
    func changeHidingState(previousState: Bool, completion: @escaping (Result<Bool, FeedOrderError>) -> Void
    )
    func makeSwap(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void)
}

struct UserAPIService:  EditProfileFetcher {
    public static let shared = UserAPIService()
    
    private enum RequestUrl {
        case getMyProfile
        case createOrder
        case uploadImage
        func getUrl() -> URL? {
            switch self {
            
            case .getMyProfile:
                return URL(string: "http://92.63.105.87:3000/user/getProfile")
            case .createOrder:
                return URL(string: "http://92.63.105.87:3000/order/makeNew")
            case .uploadImage:
                return URL(string: "http://92.63.105.87:3000/image/upload")
            }
        }
    }
    
    
    func updateProfileInfo(model: EditProfileViewModel, completion: @escaping (Result<Void, MyProfileError>) -> Void) {
        #warning("TODO")
        completion(.success(Void()))
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
        
        completion(.success(EditProfileViewModel(name: "Ярослав",
                                                 lastname: "Иванов",
                                                 city: "Москва",
                                                 phoneNumber: "89878182398",
                                                 imageStringUrl:  "https://strana.ua/img/article/2625/70_main.jpeg")))
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<MyProfileOrderResponse, MyProfileError>) -> Void) {
        completion(.success(MyProfileOrderResponse(orderId: 123,
                                                   title: "Делаю необычные татууу",
                                                   description: "Ищу моделей для своего портфолио в инстаграм. Можете посмотреть уже готовые работы @okxytatt.",
                                                   counterOffer: "Я бы хотела научиться читать рэп или взять пару уроков по битбоксу.",
                                                   isFree: true,
                                                   tags: ["IT, интернет", "Бытовые услуги", "Исскуство","Красота, здоровье" ],
                                                   photoAttachments: [
                                                   "https://strana.ua/img/article/2625/70_main.jpeg",
                                                   "https://avatarko.ru/img/kartinka/1/avatarko_anonim.jpg",
                                                   "https://happypik.ru/wp-content/uploads/2019/09/odinokij-volk16.jpg"],
                                                   isHidden: true)))
        
    }
    public func getMyProfile(completion: @escaping (Result<MyProfileViewModel, MyProfileError>) -> Void) {
//        completion(.success(MyProfileViewModel(
//                                personInfo: MyProfileViewModel.PersonInfo(profileImage: "https://i.pinimg.com/474x/bc/d4/ac/bcd4ac32cc7d3f98b5e54bde37d6b09e.jpg",
//                                                                          name: "Ярослав",
//                                                                          lastname: "Иванов",
//                                                                          cityName: "Москва",
//                                                                          swapsCount: 99,
//                                                                          raiting: 4.6),
//                                feedInfo: MyProfileViewModel.FeedModel(cells: [
//                                    MyProfileViewModel.FeedModel.Cell.init(orderId: 123, title: "Научу писать продающие тексты для инстаграма", description: "Научу их писать", counterOffer: "В обмен хочу чтобы ты решил за меня линал", photo: nil, isFree: false, isHidden: false),
//
//MyProfileViewModel.FeedModel.Cell.init(orderId: 2, title: "Научу плавать", description: "Занимаюсь плаваньем профессионально 10 лет", counterOffer: "Научите меня играть на гитаре", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: false),
//
//MyProfileViewModel.FeedModel.Cell.init(orderId: 4, title: "Научу кататься на борде", description: "Катаю с детства, знаю огромное количество трюков, обожаю фрирайд, люблю экстримальные виды спорта, а также прогать; Увлекаюсь математикой, поэтому по ходу помогу выучить линал; Да когда эта лента уже закончится ", counterOffer: "Научите меня серфить", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: false, isHidden: true),
//MyProfileViewModel.FeedModel.Cell.init(orderId: 2, title: "Научу плавать", description: "Занимаюсь плаваньем профессионально 10 лет", counterOffer: "Научите меня играть на гитаре", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: false),
//
//MyProfileViewModel.FeedModel.Cell.init(orderId: 4, title: "Научу кататься на борде", description: "Катаю с детства, знаю огромное количество трюков, обожаю фрирайд, люблю экстримальные виды спорта, а также прогать; Увлекаюсь математикой, поэтому по ходу помогу выучить линал; Да когда эта лента уже закончится ", counterOffer: "Научите меня серфить", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: true)
//]))))
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
                        print(data)
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
    }
    
    
}

//MARK: - FullOrderFetcher
extension UserAPIService: FullOrderFetcher {
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
        completion(.success(Void()))
    }
    
    func changeHidingState(previousState: Bool, completion: @escaping (Result<Bool, FeedOrderError>) -> Void) {
        print(#function)
        completion(.success(true))
        
    }
    
    func makeSwap(orderId: Int, completion: @escaping (Result<Void, FeedOrderError>) -> Void) {
        print(#function)
        completion(.success(Void()))
    }
    
    
}
