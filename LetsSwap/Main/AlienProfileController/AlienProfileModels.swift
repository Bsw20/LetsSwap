//
//  AlienProfileModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum AlienProfile {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getProfile(userId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentFullProfile(result: Result<ProfileResponse, AlienProfileError>)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFullProfile(profileViewModel: ProfileViewModel)
      }
    }
  }
  
}
