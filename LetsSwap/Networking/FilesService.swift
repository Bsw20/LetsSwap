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
            return URL(string: ServerAddressConstants.JAVA_SERVER_ADDRESS + path)
        }
        
        var image: UIImage? {
            nil
        }
        
        var placeholderImage: UIImage {
            UIImage(named: "image__placeholder") ?? UIImage()
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
        }
    }

    public func uploadFile(fileData: Data, fileName: String = "IMG.png", completion: @escaping(Result<File, Error>) -> ()) {
        var newFileData = fileData

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
                    completion(.success(model))
                    return
                } catch(let error){
                    print(error)
                    completion(.failure(NSError()))
                }
            case .failure(let error):
                print(result.debugDescription)
                print(error)
                completion(.failure(error))
            }

        }
    }
}
