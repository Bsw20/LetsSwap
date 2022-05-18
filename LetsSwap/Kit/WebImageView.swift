//
//  WebImageView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.12.2020.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyBeaver

class WebImageView: UIImageView {
    private var service = UserAPIService.shared
    private var imagePlaceholder: UIImage? {
        didSet {
//            print(self.image)
            if self.image == nil {
                self.image = imagePlaceholder
            }
        }
    }
    
    public func setPlaceholder(placeholder: UIImage?) {
        imagePlaceholder = placeholder
    }
    
    private var currentUrlSring: String?
    private let modifier = AnyModifier { request in
        var r = request
        #warning("replace Access-Token with the field name")
        r.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMjg2MDA3fQ.wlfqicWguYFBA3UauWi-04_cCHHY_fhgG_SBVKAk6hk", forHTTPHeaderField: "Authorization")
        return r
    }
    public var getCurrentUrl: StringURL {
        print(#function)
        print(currentUrlSring)
        return currentUrlSring
    }
    
    public func resetUrl() {
        self.image = imagePlaceholder
        self.currentUrlSring = nil
    }
    
    public func set(imageURL: String?, placeholder: UIImage? = nil, completion: ( (Result<RetrieveImageResult, KingfisherError>)->())? = nil) {
        self.imagePlaceholder = placeholder
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            resetUrl()
            return
        }
        
        kf.indicatorType = .activity
        self.currentUrlSring = imageURL
        kf.setImage(with: url, placeholder: self.imagePlaceholder , options: [.requestModifier(modifier)]) { [weak self] (result) in
            switch result {
            
            case .success(let data):
                break
            case .failure(let error):
                self?.image = self?.imagePlaceholder
            }
            completion?(result)
        }
    }
    
}
