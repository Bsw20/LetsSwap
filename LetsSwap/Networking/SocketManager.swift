//
//  SocketManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 15.02.2021.
//

import Foundation
import UIKit
import SocketIO
import Combine
import SwiftyJSON
import SwiftyBeaver

final class Socket: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "ws://92.63.105.87:3000")!, config: [.log(true), .compress, .connectParams(["token": APIManager.getToken()])])
    
//    @Published var messages = [String]()
    var socket: SocketIOClient!
    
    private static var instance: Socket? = nil
    public static var shared: Socket {
        if let instance = instance {
            return instance
        }
        instance = Socket()
        return instance!
    }
    private init() {
        socket = manager.defaultSocket
        socket.disconnect()
        socket.on(clientEvent: .connect) { [weak self](data, ack) in
            print("connected---------------")
        }
        

        
        
        socket.connect()
    }
    
    public func listenForNotifications(completion: @escaping (Result<Void, Error>) -> Void ) {
        socket.on("serverNotifications") {(data, ack) in
            print("NOTIFICATION")
            print(data)
            completion(.success(Void()))
        }
    }
    
    public func sendMessage(model: MessageModel, completion: @escaping (Result<Void, Error>) -> Void ) {
        print(model.representation())
        socket.emit("SendMessage", model.representation()) {
            completion(.success(Void()))
        }
    }
    
    public func listenForMessages(completion: @escaping (Result<MessageModel, Error>) -> Void ) {
        socket.on("GetMessage") { (data, ack) in
            print(#function)
            print(data)
//            print(ack)
            completion(Socket.parseToMessageModel(data: data))
        }
    }
    
    public func disconnectSocket(completion: @escaping (Result<Void, Error>) -> Void ) {
        socket.disconnect()
        completion(.success(Void()))
    }
    
    public func stopListenForMessages() {
        socket.off("GetMessage")
    }
    
    struct MessageModel : SocketData {
        let messageId: String
        let chatId: Int
        let contentType: String
        let content: String
        let displayName: String
        let senderId: String
        let sendDate: Date
        

       func representation() -> SocketData {
           return ["messageId": messageId,
                   "chatId": chatId,
                   "contentType": contentType,
                    "content": content
           ]
       }
    }
}

//MARK: - Mapping
extension Socket {
    static func parseToMessageModel(data: Any) -> Result<MessageModel, Error> {
        guard let firstData = data as? [Any] else {
            SwiftyBeaver.error("Incorrect model, it must be json")
            return .failure(NSError())
        }
        guard let data = firstData[0] as? [String: Any] else {
            SwiftyBeaver.error("Incorrect model, it must be json")
            return .failure(NSError())
        }
        let json = JSON(data)
        let format = DateFormatter()
         
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let chatId = json["chatId"].int,
              let senderId = json["senderId"].int,
              let content = json["message"].string,
              let contentType = json["contentType"].string,
              let displayName = json["senderName"].string,
              let messageId = json["messageId"].string,
              let stringSendDate = json["date"].string,
              let sendDate = format.date(from: stringSendDate)
        else {
            SwiftyBeaver.error("Incorrect model")
            return .failure(NSError())
        }
        return .success(.init(messageId: messageId,
                              chatId: chatId,
                              contentType: contentType,
                              content: content,
                              displayName: displayName,
                              senderId: String(senderId),
                              sendDate: sendDate))
    }
}

