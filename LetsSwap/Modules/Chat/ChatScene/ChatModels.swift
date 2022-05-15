//
//  ChatModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import MessageKit

protocol CMessageModel {
    var messageId: String {get}
    var chatId: Int {get}
    var messageText: String? { get}
    var file: FilesService.File? { get }
    var sentDate: Date { get }
    var forward: Int? { get }
    var replyTo: Int? { get }
}

enum Chat {
    
    struct CChat {
        var friendAvatarStringURL: String?
        var friendId: Int
        var friendUsername: String
        var chatId: Int
    }
    enum AllMessages {
        struct Request {
            var chatId: Int
        }
        struct Response {
            var messages: [CMessage]
        }
        struct ViewModel {
            var messages: [CMessage]
        }
    }
    struct File {
        var createDate: String
        var id: String
        var name: String
        var path: String
        var size: Int32
        var type: String
    }
    
    struct CUser {
        var username: String
        var avatarStringURL: String?
        var id: String
    }

    class CMessage: Hashable, Comparable, MessageType, CMessageModel {

        var kind: MessageKind {
            if let file = file {
                if file.type == "MP4" || file.type == "MOV" {
                    return .video(file)
                }
                return .photo(file)
            }
            return .text(messageText ?? "empty text")
        }
        // Other
        var sender: SenderType
        var sentDate: Date
        //IDs
        var chatId: Int
        var messageId: String
        var forward: Int?
        var replyTo: Int?
        //Content
        var messageText: String?
        var file: FilesService.File?
        
        init(user: CUser, chat: CChat, messageText: String) {
            self.messageText = messageText
            sender = Sender(senderId: user.id, displayName: user.username)
            sentDate = Date()
            messageId = UUID().uuidString
            chatId = chat.chatId
        }
        
        init(user: CUser, chat: CChat, file: FilesService.File) {
            sender = Sender(senderId: user.id, displayName: user.username)
            sentDate = Date()
            messageId = UUID().uuidString
            chatId = chat.chatId
            self.file = file
        }

        init(messageId: String, senderId: String, displayName: String, messageText: String?, sendDate: Date, chatId: Int, file: FilesService.File?) {
            self.messageId = messageId
            sender = Sender(senderId: senderId, displayName: displayName)
            self.sentDate = sendDate
            self.messageText = messageText
            self.chatId = chatId
            self.file = file
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
