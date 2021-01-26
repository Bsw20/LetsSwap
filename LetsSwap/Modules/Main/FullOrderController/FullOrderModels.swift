//
//  FullOrderModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum FullOrder {
   
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

enum FullOrderViewType {
    case create
    case edit
}
