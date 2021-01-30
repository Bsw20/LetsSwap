//
//  SignUpModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SignUp {
   
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


struct SignUpViewModel {
    var name: String
    var lastName: String
    var city: String
    var login: String
    var smsCode: String?
    
    var representation: [String: Any] {
        var rep = ["name": name]
        rep["lastName"] = lastName
        rep["city"] = city
        rep["login"] = login
        rep["smsCode"] = smsCode ?? ""
        return rep
    }
}
