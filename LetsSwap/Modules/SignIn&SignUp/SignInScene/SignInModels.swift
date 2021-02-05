//
//  SignInModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

enum SignIn {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
      }
    }
    struct Response {
      enum ResponseType {
        case some
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
      }
    }
  }
  
}

struct SignInViewModel {
    var login: String
    var smsCode: String?
    
    var representation: [String: Any] {
        var rep = ["login": login]
        rep["smsCode"] = smsCode ?? ""
        return rep
    }
}
