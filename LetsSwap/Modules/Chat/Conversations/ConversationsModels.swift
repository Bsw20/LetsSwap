//
//  ConversationsModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Conversations {
    struct Conversation: ConversationCellViewModel {
        
        var profileImage: String?
        var name: String
        var lastname: String
        var missedMessagesCount: Int
        var lastMessage: String
        var data: Int
        
        
    }
   
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
