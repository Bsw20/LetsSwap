//
//  ConversationsModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Conversations {
    struct Conversation: ConversationCellViewModel, Decodable {
        
        var friendAvatarStringURL: String?
        var friendId: Int
        var name: String
        var lastName: String
        var missedMessagesCount: Int
        var lastMessageContent: String
        var date: String
        var chatId: Int
        
        
    }
    struct MyProfileInfo {
        var myId: Int
        var myProfileImage: String?
        var myUserName: String
    }
    
    enum AllConversations {
        struct Request {
        }
        
        struct Response: Decodable {
            var chats: [Conversation]
            var myId: Int
            var myProfileImage: String?
            var myUserName: String
        }
        
        struct ViewModel: Decodable {
            var chats: [Conversation]
            var myId: Int
            var myProfileImage: String?
            var myUserName: String
        }
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
