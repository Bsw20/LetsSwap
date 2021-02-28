
//  ChatInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import SwiftyBeaver
import SwiftyJSON

protocol ChatBusinessLogic {
    func sendMessage(request: Chat.CMessage)
    func getAllMessages(request: Chat.AllMessages.Request)
}

class ChatInteractor: ChatBusinessLogic {
    //MARK: - Variables
    typealias Message = Chat.CMessage
    private var service: ChatManager = ChatManager.shared
    
    func getAllMessages(request: Chat.AllMessages.Request) {
        SwiftyBeaver.info(#function)
        service.getAllMessages(chatId: request.chatId) {[weak self] (result) in
             print(#function)
//            SwiftyBeaver.info(#function)
            switch result {
            
            case .success(let model):
                SwiftyBeaver.verbose("Very important")
                let messages = ChatInteractor.parseToAllMessages(data: model)
                self?.presenter?.presentAllMessages(model: .init(messages: messages))
                
                
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
        
    }
    
    var presenter: ChatPresentationLogic?
    
    func sendMessage(request: Chat.CMessage) {
    }
}

//MARK: - Mapping
extension ChatInteractor {
    static func parseToAllMessages(data: [String: Any]) -> [Message] {
        let format = DateFormatter()
         
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        print(format.string(from: Date()))
        let data = JSON(data)
//        print(data)
        guard let _ = data["chatId"].string, let chatId = Int(data["chatId"].string!) else {
            SwiftyBeaver.error("Can't parse chatId")
            return []
        }

        let messages = JSON(data)["messages"].arrayValue

        return
            messages
            .compactMap{
                guard
                    let messageId =  $0["id"].string,
                    let senderId =  $0["sender"]["senderId"].int,
                    let displayName =  $0["sender"]["displayName"].string,
                    let content = $0["content"].string,
                    let stringSendDate = $0["sentDate"].string,
                    let sendDate = format.date(from: stringSendDate)
                      else {
                        SwiftyBeaver.error("Incorrect model")
                        return nil
                }
               return  Message(messageId: messageId,
                                senderId: String(senderId),
                                displayName: displayName,
                                content: content,
                                sendDate: sendDate,
                                chatId: chatId)}
    }
}
