//
//  AppDelegate.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 09.12.2020.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(APIManager.getToken())
        UNUserNotificationCenter.current().delegate = self
        if let notificationOption = launchOptions?[.remoteNotification] {
            print("remote notification options exists in app delegate")
        }
        registerForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
          completionHandler(.failed)
          return
        }
        
        print("fetch remoate notification in didReceiveRemoteNotification")
        print(userInfo)
//        NewsItem.makeNewsItem(aps)
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
        AuthService.shared.sendAPNSToken(token: token) { result in
            switch result {
            case .success():
                print("Ssssuccess")
            case .failure(let error):
                print("error apns")
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
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
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
