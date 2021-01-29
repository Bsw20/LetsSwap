//
//  AppCoordinator.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.01.2021.
//

import Foundation
import UIKit
protocol AuthFinishedDelegate: AnyObject {
    func authFinished()
}

class AppCoordinator {
    private let contentWindow: UIWindow
    
    init(contentWindow: UIWindow) {
        self.contentWindow = contentWindow
    }
    
    public func start() {
//        startPresentation()
//        startSignIn()
        startSignUp()
//        startMain()
    }
    
    private func startAuth() {
    }
    
    private func startPresentation() {

        let presentationVC = SignUpPresentationViewController(presentationSlide: .firstSlide)
        let navigationVC = UINavigationController(rootViewController: presentationVC)
        contentWindow.rootViewController = navigationVC
    }
    private func startSignIn() {
        let signInVC = SignInViewController()
        contentWindow.rootViewController = UINavigationController(rootViewController: signInVC)
    }
    
    private func startSignUp() {
        let signUpVC = SignUpViewController()
        contentWindow.rootViewController = UINavigationController(rootViewController: signUpVC)
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

extension AppCoordinator: AuthFinishedDelegate {
    func authFinished() {
        startMain()
    }
}
