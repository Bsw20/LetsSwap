//
//  AppDelegate.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 09.12.2020.
//

import UIKit
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum NotificationType {
        case chat
        case swapConfirmed
        case swapRecieved
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(APIManager.getToken())
        let config = Realm.Configuration(
                schemaVersion: 3 ,
                migrationBlock: { _, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                    }
                })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        UNUserNotificationCenter.current().delegate = self
        if let notificationOption = launchOptions?[.remoteNotification] {
            print("remote notification options exists in app delegate")
        }
        registerForPushNotifications()
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            print(aps)
            notificationRecieved(notification: notification)
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let notification = userInfo["aps"] as? [String: AnyObject] else {
          completionHandler(.failed)
          return
        }
        print(notification)
        notificationRecieved(notification: notification)
        //completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apns = deviceToken.hexString
        print(apns)
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        if APIManager.isAuthorized() {
            AuthService.shared.sendAPNSToken(token: token) { result in
                switch result {
                case .success():
                    print("Ssssuccess")
                case .failure(let error):
                    print("error apns")
                }
            }
        }

    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
          print("Permission granted: \(granted)")
          guard granted else { return }
        self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func notificationRecieved(notification: [String: AnyObject]) {
        print("lol")
        if let tabBarController = (SceneDelegate.shared().appCoordinator?.contentWindow.rootViewController as? UITabBarController), let type = notificationParser(notification: notification) {
            print("kek")
            switch type {
            case .chat:
                tabBarController.selectedIndex = 2
                if let chatId = notification["chatId"] {
                    let vc = ChatViewController(conversation: nil, userInfo: nil, chatId: chatId as? Int)
                    tabBarController.navigationController?.push(vc)
                }
            case .swapConfirmed:
                tabBarController.selectedIndex = 3
            case .swapRecieved:
                tabBarController.selectedIndex = 3
            }
        }
    }
    
    func notificationParser(notification: [String: AnyObject]) -> NotificationType? {
        if let message = notification["alert"] as? String {
            if message.contains("сообщение") {
                return .chat
            } else if message.contains("подтверждён") {
                return .swapConfirmed
            } else if message.contains("мах") {
                return .swapRecieved
            }
        }
        return nil
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        guard let notification = userInfo["aps"] as? [String: AnyObject] else {
          return
        }
        print(notification)
        notificationRecieved(notification: notification)
        // По идее тут должен быть переход в чат и во вкладку с уведомлениями
//        if
//          let aps = userInfo["aps"] as? [String: AnyObject],
//          let newsItem = NewsItem.makeNewsItem(aps) {
//          (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//
//          // 3
//          if response.actionIdentifier == Identifiers.viewAction,
//            let url = URL(string: newsItem.link) {
//            let safari = SFSafariViewController(url: url)
//            window?.rootViewController?
//              .present(safari, animated: true, completion: nil)
//          }
//        }
        
    }
    
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
      ) {
          let userInfo = notification.request.content.userInfo
          //notification.request.content.title = "123"
          print(userInfo)
          completionHandler([ .alert, .badge ])
      }

}

extension Data {
    var hexString: String {
        let hexString = map {
            String(format: "%02.2hhx", $0)
        }.joined()
        return hexString
    }
}
