//
//  WebImageView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.12.2020.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    private var service = UserAPIService.shared
    
    private var currentUrlSring: String?
    public var getCurrentUrl: StringURL {
        return currentUrlSring
    }
    
    public func set(imageURL: String?) {
        currentUrlSring = imageURL
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return
            
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        
//        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            DispatchQueue.main.async {
//                if let data = data, let response = response  {
//                    self?.handleLoadedImage(data: data, response: response)
//                }
//            }
//        }
//        dataTask.resume()
        service.downloadImage(url: imageURL) { (result) in
            switch result {
            
            case .success(let data):
                DispatchQueue.main.async {
//                    self.handleLoadedImage(data: data, response: <#T##URLResponse#>)
                    self.image = UIImage(data: data)
                }
            case .failure(let error):
                #warning("TODO")
                print("ОШИБКА ПРИ ЗАГРУЗКЕ ФОТО")
                print(error)
            }
        }
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentUrlSring {
            self.image = UIImage(data: data)
        }
    }
    
}
