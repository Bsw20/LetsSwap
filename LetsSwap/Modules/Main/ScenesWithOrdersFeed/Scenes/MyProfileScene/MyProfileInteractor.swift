//
//  MyProfileInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfileBusinessLogic {
  func makeRequest(request: MyProfile.Model.Request.RequestType)
}

class MyProfileInteractor: MyProfileBusinessLogic {

    var presenter: MyProfilePresentationLogic?
    private var fetcher: MyProfileFetcher = UserAPIService.shared
    
  
    func makeRequest(request: MyProfile.Model.Request.RequestType) {
        
        switch request {
        
        case .getWholeProfile:
            fetcher.getMyProfile { [weak self] (result) in
                self?.presenter?.presentData(response: .presentWholeProfile(result: result))
            }
        case .getOrder(orderId: let id):
            fetcher.getOrder(orderId: id) {[weak self] (result) in
                self?.presenter?.presentData(response: .presentOrder(result: result))
            }
        case .getFullProfileInfo:
            fetcher.getFullProfileModel { [weak self](result) in
                self?.presenter?.presentData(response: .presentFullProfileInfo(result: result))
            }
        }
    }
}
