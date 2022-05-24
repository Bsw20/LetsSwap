//
//  MyProfileInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
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
                switch result {
                
                case .success(let model):
                    let newModel = self?.getProfileModel(oldModel: model)
                    if let newModel = newModel {
                        self?.presenter?.presentData(response: .presentWholeProfile(result: .success(newModel)))
                    } else {
                        self?.presenter?.presentData(response: .presentWholeProfile(result: .failure(.incorrectDataModel)))
                    }
                case .failure(let error):
                    self?.presenter?.presentData(response: .presentWholeProfile(result: .failure(error)))
                }
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
    
    private func getProfileModel(oldModel: MyProfileResponseModel) -> MyProfileViewModel  {
        let rating = oldModel.personInfo.swapsCount == 0 ? 0 : ((oldModel.personInfo.rating / Double(oldModel.personInfo.swapsCount)) * 10).rounded() / 10
        return MyProfileViewModel(
            personInfo: MyProfileViewModel.PersonInfo(profileImage: oldModel.personInfo.profileImage,
                                                      name: oldModel.personInfo.name,
                                                      lastname: oldModel.personInfo.lastname,
                                                      cityName: oldModel.personInfo.cityName,
                                                      swapsCount: oldModel.personInfo.swapsCount,
                                                      rating: rating),
            feedInfo: MyProfileViewModel.FeedModel.init(cells: oldModel.feedInfo.map{ MyProfileViewModel.FeedModel.Cell.init(orderId: $0.orderId , title: $0.title, description: $0.description, counterOffer: $0.counterOffer, photo: getUrl(str: $0.photo) , isFree: $0.isFree, isHidden: $0.isHidden)}))
    }
    
    private func getUrl(str: String?) -> URL? {
        var url: URL? = nil
        if let string = str {
            url = URL(string: string)
        }
        return url
    }
}
