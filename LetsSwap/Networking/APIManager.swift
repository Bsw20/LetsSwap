//
//  APIManager.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.02.2021.
//

import Foundation
import UIKit
import SwiftyBeaver


struct APIManager {
    static func setToken(token: String) {
        SwiftyBeaver.info("token was updated")
        UserDefaults.standard.set(token, forKey: "userSecret")
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    static func getToken() -> String {
       return UserDefaults.standard.object(forKey: "userSecret") as? String ?? ""
    }
    
    static func isAuthorized() -> Bool {
        return getToken() !=  ""
    }
    
    static func logOut() {
        setToken(token: "")
        AuthService.shared.token = nil
        AuthService.shared.removeAPNSToken()
        RealmManager.shared.deleteAllData()
        SceneDelegate.shared().appCoordinator?.startSignIn()
        SwiftyBeaver.info("User log out")
    }
    static var serverAddress: String {
        return "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)"
    }
}
