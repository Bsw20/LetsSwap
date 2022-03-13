//
//  FilesService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 30.07.2021.
//

import Foundation
import UIKit
import Alamofire
import MessageKit

class FilesService {
    struct File: Codable, MediaItem {
        var url: URL? {
            return URL(string: ServerAddressConstants.MAIN_SERVER_ADDRESS + path)
        }
        
        var image: UIImage? {
            nil
        }
        
        var placeholderImage: UIImage {
            #imageLiteral(resourceName: "RU-ICON")
        }
        
        var size: CGSize {
            CGSize(width: 400, height: 400)
        }
        
        var id: Int
        var name: String
        var path: String
        var type: String
    }
    static let shared = FilesService()
    
    public func downloadFile(url: URL?, completion: @escaping(Data?) -> ()) {
        guard let url = url else { return }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                
                case .success(let data):
                    guard let data = data else {return}
                    completion(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
//            guard let status = response.response?.statusCode else { return }
//                switch response
//            switch response
//            switch status {
//            case 200 :
//                guard let data = response.data else {return}
//                let decoder = JSONDecoder()
//                do {
//                    DispatchQueue.main.async {
//                        completion?(data)
//                    }
//                } catch let error{
//                    print(error.localizedDescription)
//                    print("it is an error")
//                }
//            }
        }
                //                s
    }

    public func uploadFile(fileData: Data, fileName: String = "IMG.png", completion: @escaping(File) -> ()) {
//        var newFileData: Data = #imageLiteral(resourceName: "RU-ICON").pngData()!
        var newFileData = fileData
//        if fileData == nil {
//            fileData = #imageLiteral(resourceName: "tatu").pngData()
//        }
        let url = ServerAddressConstants.UPLOAD_FILE
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization" : APIManager.getToken()
        ]
        

        AF.upload(multipartFormData: { (multiPart) in
            multiPart.append(fileData, withName: "dataFile", fileName: fileName, mimeType: "image/jpeg")
        }, to: url, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { (result) in

            switch result.result {
            
            case .success(let data):
                guard let dataInfo = result.data else {
                    print("NO DATA")
                    return
                }
                print(data)
                do {
                    let model = try JSONDecoder().decode(File.self, from: dataInfo)
                    print(model)
                    print(model.url)
                    completion(model)
                } catch(let error){
                    print(error)
                }
            case .failure(let error):
                print(result.debugDescription)
                print(error)
//                SwiftyBeaver.error(error.localizedDescription)
//                completion(.failure(APIErrorFabrics.serverError(code: error.responseCode)))
            }

        }
    }
}