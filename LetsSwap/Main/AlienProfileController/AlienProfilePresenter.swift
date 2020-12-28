//
//  AlienProfilePresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AlienProfilePresentationLogic {
  func presentData(response: AlienProfile.Model.Response.ResponseType)
}

class AlienProfilePresenter: AlienProfilePresentationLogic {
  weak var viewController: AlienProfileDisplayLogic?
  
  func presentData(response: AlienProfile.Model.Response.ResponseType) {
    switch response {
    
    case .presentFullProfile(result: let result):
        switch result {
        
        case .success(let profile):
            let feedViewModel = FeedPresenter.getFeedViewModel(feed: profile.feedResponse)
            let profileDescrViewModel = AlienProfilePresenter.getProfileDescriptionViewModel(profileDescription: profile.userDescription)
            let profileViewModel = ProfileViewModel(userId: profile.userId, feedViewModel: feedViewModel, profileDescription: profileDescrViewModel)
            viewController?.displayData(viewModel: .displayFullProfile(profileViewModel: profileViewModel))
            
        case .failure(let error):
            print("error")
        }
    }
  }
    static func getProfileDescriptionViewModel(profileDescription: ProfileDescription) -> ProfileDescriptionViewModel{
        var url: URL? = nil
        if let stringURL = profileDescription.userPhoto?.url{
            url = URL(string: stringURL)
        }
        
        return ProfileDescriptionViewModel.init(userPhoto: url,
                                                swapsCount: profileDescription.swapsCount,
                                                raiting: profileDescription.raiting,
                                                name: profileDescription.name,
                                                lastName: profileDescription.lastName,
                                                cityName: profileDescription.cityName)
    }
}
