//
//  ConversationsInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyBeaver

protocol ConversationsBusinessLogic {
    func makeRequest(request: Conversations.Model.Request.RequestType)
    func getAllConversations(requst: Conversations.AllConversations.Request)
}

class ConversationsInteractor: ConversationsBusinessLogic {

    
    typealias ConversationModel = Conversations.Conversation
    typealias ConversationViewModel = Conversations.AllConversations.Response
    var presenter: ConversationsPresentationLogic?
    var service: ConversationsService?
    
    var manager: ConversationsManager = ChatManager.shared
  
    func makeRequest(request: Conversations.Model.Request.RequestType) {
        if service == nil {
            service = ConversationsService()
        }
    }
    
    func getAllConversations(requst: Conversations.AllConversations.Request) {
        manager.getAllConversations {[weak self] (result) in
            switch result {
             
            case .success(let data):
                if let model = self?.parseToAllConversations(anyData: data) {
                    self?.presenter?.presentAllConversations(response: model)
                    return
                }
                self?.presenter?.presentError(error: NSError())
                
            case .failure(let error):
                self?.presenter?.presentError(error: NSError())
            }
        }
    }
}

//MARK: - mapping
extension ConversationsInteractor {
    private func parseToAllConversations(anyData: Any) -> ConversationViewModel?{
        guard let massData = anyData as? [String: Any] else {
            SwiftyBeaver.error("Incorrect model")
            return nil
        }
        let format = DateFormatter()

        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let data = JSON(massData)
        let myProfileImage = data["myProfileImage"].string
        guard let myUserName = data["myUserName"].string,
              let myId = data["myId"].int else {
            SwiftyBeaver.error("Incorrect model")
            return nil
        }

        let conversations:[Conversations.Conversation] = JSON(data)["chats"].arrayValue.compactMap{
            let friendAvatarStringURL =  $0["friendAvatarStringURL"].string
            let lastMessageContent = $0["lastMessageContent"].string
            var sendDate = Date()
            if let stringSendDate = $0["date"].string {
                if let parsedDate = format.date(from: stringSendDate) {
                    sendDate = parsedDate
                }
            }
            
            guard let chatId =  $0["chatId"].int,
                let friendId =  $0["friendId"].int,
                let name = $0["name"].string,
                let lastName = $0["lastName"].string,
                let missedMessagesCount = $0["missedMessagesCount"].int
                  else {
                    SwiftyBeaver.error("Incorrect model")
                    return nil
            }
            return Conversations.Conversation.init(friendAvatarStringURL: friendAvatarStringURL,
                                                   friendId: friendId,
                                                   name: name,
                                                   lastName: lastName,
                                                   missedMessagesCount: missedMessagesCount,
                                                   lastMessageContent: lastMessageContent ?? "",
                                                   date: sendDate,
                                                   chatId: chatId)
            
        }
        
        return ConversationViewModel(chats: conversations,
                                     myId: myId,
                                     myProfileImage: myProfileImage,
                                     myUserName: myUserName)
        

    }
}
