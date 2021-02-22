//
//  NotificationsManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 15.02.2021.
//

import Foundation
import UIKit
import SocketIO
import Combine

final class Socket: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "ws://92.63.105.87:3000")!, config: [.log(true), .compress, .connectParams(["token": APIManager.getToken()])])
    
//    @Published var messages = [String]()
    var socket: SocketIOClient!
    
    init() {
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
}

