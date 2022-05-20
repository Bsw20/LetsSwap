
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
    func setRating(rating: Int, request: Chat.CChat)
    func deleteChat(request: Chat.AllMessages.Request)
    func changeFinished(request: Chat.CChat)
    func getChatInfo(chatId: Int)
}

class ChatInteractor: ChatBusinessLogic {
    
    
    //MARK: - Variables
    typealias Message = Chat.CMessage
    private var service: ChatManager = ChatManager.shared
    
    func getAllMessages(request: Chat.AllMessages.Request) {
        SwiftyBeaver.info(#function)
        service.getAllMessages(chatId: request.chatId) {[weak self] (result) in
             print(#function)
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
        guard let chatId = data["chatId"].int else {
            SwiftyBeaver.error("Can't parse chatId")
            return []
        }

        let messages = JSON(data)["messages"].arrayValue

        return
            messages
            .compactMap{
                switch ChatInteractor.parseToMessageModel(chatId: chatId, data: $0) {
                
                case .success(let model):
                    return model
                case .failure(let error):
                    return nil
                }
            }
    }
    
    static func parseToMessageModel(chatId: Int, data: Any) -> Result<Message, Error> {
        let json = JSON(data)
        let format = DateFormatter()
         
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let senderId = json["senderId"].int,
              let displayName = json["senderName"].string,
              let messageId = json["messageId"].string,
              let stringSendDate = json["date"].string,

              let sendDate = format.date(from: stringSendDate)
        else {
            SwiftyBeaver.error("Incorrect model")
            return .failure(NSError())
        }
        let messageText = json["messageText"].string
        let fileId = json["fileId"].int
        let fileName = json["fileName"].string
        let filePath = json["filePath"].string
        let fileExtension: String? = "FileExtension"
        var file: FilesService.File? = nil
        if let fileId = fileId, let fileName = fileName, let filePath = filePath, let fileExtension = fileExtension {
            file = .init(id: fileId,
                         name: fileName,
                         path: filePath,
                         type: fileExtension)
        }
        return .success(.init(messageId: messageId,
                              senderId: String(senderId) ,
                              displayName: displayName,
                              messageText: messageText,
                              sendDate: sendDate,
                              chatId: chatId,
                              file: file))
    }
    
    func setRating(rating: Int, request: Chat.CChat) {
        service.setRating(userId: request.friendId, rating: rating) {[weak self] (result) in
            print(#function)
           switch result {
           
           case .success(let model):
               break
               
           case .failure(let error):
               self?.presenter?.presentError(error: error)
           }
       }
    }
    
    func changeFinished(request: Chat.CChat) {
        service.changeDone(chatId: request.chatId) {[weak self] (result) in
            print(#function)
           switch result {
           
           case .success(let model):
               self?.presenter?.closeView()
               break
               
           case .failure(let error):
               self?.presenter?.presentError(error: error)
           }
       }
    }
    
    func deleteChat(request: Chat.AllMessages.Request) {
        SwiftyBeaver.info(#function)
        service.deleteChat(chatId: request.chatId) {[weak self] (result) in
             print(#function)
            switch result {
            
            case .success(let model):
                self?.presenter?.closeView()
                
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }
    
    func getChatInfo(chatId: Int) {
        SwiftyBeaver.info(#function)
        service.getChatData(chatId: chatId) {[weak self] (result) in
             print(#function)
            switch result {
            
            case .success(let data):
                if let model = ChatInteractor.parseToOtherProfile(data: data) {
                    self?.presenter?.presentData(model: model)
                } else {
                    self?.presenter?.presentError(error: MyProfileError.incorrectDataModel)
                }
                break
                
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }
    
    static func parseToOtherProfile(data: Any) -> Conversations.OtherProfileInfo? {
        guard let dictionary = data as? [String: AnyObject] else {return nil}
        let model = Conversations.OtherProfileInfo(lastName: dictionary["lastname"] as! String, name: dictionary["name"] as! String, photoUrl: dictionary["photoUrl"] as? String, id: dictionary["id"] as! Int, myId: dictionary["myId"] as? Int)
        return model
    }
}
