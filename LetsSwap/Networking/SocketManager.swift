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
//            self?.socket.emit("NodeJS Server Port", "Hi Node.JS server!")
        }
        
        socket.on("serverNotifications") {(data, ack) in
            print("NOTIFICATION")
            print(data)
        }
        
        
        socket.connect()
    }
    
    public func sendMessage(model: MessageModel, completion: @escaping (Result<Void, Error>) -> Void ) {
        print(model.representation())
        socket.emit("SendMessage", model.representation()) {

        }
    }
    
    public func listenForMessages(completion: @escaping (Result<MessageModel, Error>) -> Void ) {
        socket.on("GetMessage") { (data, ack) in
            print(data)
//            print(ack)
            completion(Socket.parseToMessageModel(data: data))
        }
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
        
        guard let chatId = json["chatId"].int,
              let senderId = json["from"].int,
              let content = json["message"].string,
              let contentType = json["contentType"].string else {
            SwiftyBeaver.error("Incorrect model")
            return .failure(NSError())
        }
        #warning("Доделать модель")
        return .success(.init(messageId: UUID().uuidString, chatId: chatId, contentType: contentType, content: content, displayName: "Ярослав Петров", senderId: String(senderId), sendDate: Date()))
    }
    
//    static func parseToAllMessages(data: [String: Any]) -> [Message] {
//        let format = DateFormatter()
//
//        format.timeZone = .current
//        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        print(format.string(from: Date()))
//        let data = JSON(data)
////        print(data)
//        guard let _ = data["chatId"].string, let chatId = Int(data["chatId"].string!) else {
//            SwiftyBeaver.error("Can't parse chatId")
//            return []
//        }
//
//        let messages = JSON(data)["messages"].arrayValue
//
//        return
//            messages
//            .compactMap{
//                guard
//                    let messageId =  $0["id"].string,
//                    let senderId =  $0["sender"]["senderId"].int,
//                    let displayName =  $0["sender"]["displayName"].string,
//                    let content = $0["content"].string,
//                    let stringSendDate = $0["sentDate"].string,
//                    let sendDate = format.date(from: stringSendDate)
//                      else {
//                        SwiftyBeaver.error("Incorrect model")
//                        return nil
//                }
//               return  Message(messageId: messageId,
//                                senderId: String(senderId),
//                                displayName: displayName,
//                                content: content,
//                                sendDate: sendDate,
//                                chatId: chatId)}
//    }
}

