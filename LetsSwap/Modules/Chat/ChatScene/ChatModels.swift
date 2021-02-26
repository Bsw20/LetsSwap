//
//  ChatModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import MessageKit
enum Chat {
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
    
    enum AllMessages {
        struct Request {
            
        }
        struct Response {
        }
        struct ViewModel {
            
        }
    }
    
    struct CMessage: Hashable, MessageType {
        var messageId: String
        
        var kind: MessageKind {
            return .text(content)
        }
        var sender: SenderType
        let content: String
        let sentDate: Date
        let chatId: String?
        
        
        static func == (lhs: Chat.CMessage, rhs: Chat.CMessage) -> Bool {
            return lhs.messageId == rhs.messageId
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(messageId)
        }
        
        static func < (lhs: CMessage, rhs: CMessage) -> Bool {
            return lhs.sentDate < rhs.sentDate
        }

    }
  
}
