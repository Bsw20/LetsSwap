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
    
    struct CChat {
        var friendAvatarStringURL: String?
        var friendId: Int
        var name: String
        var lastName: String
        var missedMessagesCount: Int
        var lastMessageContent: String
        var date: String
        var chatId: Int
    }
    enum AllMessages {
        struct Request {
            
        }
        struct Response {
        }
        struct ViewModel {
            
        }
    }
    
    struct CUser {
        var username: String
        var avatarStringURL: String
        var id: String
    }
    
    struct CMessage: Hashable, MessageType {
        var messageId: String
        
        var kind: MessageKind {
            return .text(content)
        }
        var sender: SenderType
        let content: String
        let sentDate: Date
        let chatId: Int
        
        init(user: CUser, chat: CChat, content: String) {
            self.content = content
            sender = Sender(senderId: user.id, displayName: user.username)
            sentDate = Date()
            messageId = UUID().uuidString
            chatId = chat.chatId
        }
        
        
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
