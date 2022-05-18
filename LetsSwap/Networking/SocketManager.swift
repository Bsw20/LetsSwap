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
    private var manager = SocketManager(socketURL: URL(string: "ws://84.201.150.166:3030")!, config: [.log(true), .compress, .connectParams(["token": APIManager.getToken()])])
    

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
            print(#function)
            print("NOTIFICATION")
            print(data)
            completion(.success(Void()))
        }
    }
    
    public func sendMessage(model: MessageModel, completion: @escaping (Result<Void, Error>) -> Void ) {
        print(model.representation())
        let newRepresentation: [String: Any]  = [
            "chatId": model.chatId,
            "forward": "",
            "dataInfo": "",
            "id": model.messageId,
        ]
        print(model.representation())
        print(model.socketRepresentation())
        socket.emit("SendMessage", model.representation()) {
            completion(.success(Void()))
        }
    }
    
    public func listenForMessages(completion: @escaping (Result<MessageModel, Error>) -> Void ) {
        socket.on("GetMessage") { (data, ack) in
            print(#function)
            print(data)
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
        let displayName: String
        let senderId: String
        let sendDate: Date
        
        let messageId: String
        let chatId: Int
        var forward: Int? = 0
        var replyTo: Int? = 0
        
        var messageText: String?
        var file: FilesService.File?
        
        func representation() -> SocketData {
            var dataInfo: [String: Any]? = nil
            let format = DateFormatter()
             
            format.timeZone = .current
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let file = file {
                dataInfo = ["fileId": file.id,
                            "fileName": file.name,
                            "filePath": file.path,
                            "fileExtension": file.type
                ]
            }
            return ["messageId": messageId,
                    "chatId": chatId,
                    "messageText": messageText ?? nil,
                    "forward": nil,
                    "dataInfo": dataInfo ?? nil,
                    "date": format.string(from:sendDate)
                    
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
        print(firstData)
        let json = JSON(data)
        let format = DateFormatter()
         
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let chatId = json["chatId"].int,
              let senderId = json["senderId"].int,
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
        let fileExtension: String? = json["fileExtension"].string
        var file: FilesService.File? = nil
        if let fileId = fileId, let fileName = fileName, let filePath = filePath, let fileExtension = fileExtension {
            file = .init(id: fileId,
                         name: fileName,
                         path: filePath,
                         type: fileExtension)
        }
        return .success(.init(displayName: displayName,
                              senderId: String(senderId),
                              sendDate: sendDate,
                              messageId: messageId,
                              chatId: chatId,
                              forward: 0,
                              replyTo: 0,
                              messageText: messageText,
                              file: file))
    }
}


