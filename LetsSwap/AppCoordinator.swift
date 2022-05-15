//
//  AppCoordinator.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.01.2021.
//

import Foundation
import UIKit
import SwiftyBeaver

protocol AuthFinishedDelegate: AnyObject {
    func authFinished()
}

private let platform = SBPlatformDestination(appID: "B1QVk8",
                                     appSecret: "7pyCbJmsnj5bjPAvwksvhdogKRoq3Kvq",
                                     encryptionKey: "2dhrdUKksb4a23f3vwPtPstsx9yD6rzr")
class AppCoordinator {
    public let contentWindow: UIWindow
    
    init(contentWindow: UIWindow) {
        self.contentWindow = contentWindow
    }
    
    
    
    public func start() {
        SwiftyBeaver.addDestination(platform)
        SwiftyBeaver.addDestination(ConsoleDestination())
        if APIManager.isAuthorized() {
            startMain()
        } else {
            startSignIn()
        }
    }
    
    
    private func startAuth() {
    }
    
    private func startPresentation() {

        let presentationVC = SignUpPresentationViewController(presentationSlide: .firstSlide)
        let navigationVC = UINavigationController(rootViewController: presentationVC)
        navigationVC.navigationBar.barTintColor = .mainBackground()
        navigationVC.navigationBar.isTranslucent = false
        contentWindow.rootViewController = navigationVC
    }
    func startSignIn() {
        let signInVC = SignInViewController()
        let navigationVC = UINavigationController(rootViewController: signInVC)
        navigationVC.navigationBar.barTintColor = .mainBackground()
        navigationVC.navigationBar.isTranslucent = false
        contentWindow.rootViewController = navigationVC
    }
    
    private func startSignUp() {
        let signUpVC = SignUpViewController()
        let navigationVC = UINavigationController(rootViewController: signUpVC)
        navigationVC.navigationBar.barTintColor = .mainBackground()
        navigationVC.navigationBar.isTranslucent = false
        contentWindow.rootViewController = navigationVC
    }
    
    private func startMain() {
        let options: UIView.AnimationOptions = .transitionFlipFromLeft

        let duration: TimeInterval = 0.6
        UIView.transition(with: contentWindow, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
        contentWindow.rootViewController = MainTabBarController()

    }
    
}

//MARK: - AuthFinishedDelegate
extension AppCoordinator: AuthFinishedDelegate {
    func authFinished() {
        startMain()
    }
}


