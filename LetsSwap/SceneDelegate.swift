//
//  SceneDelegate.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 09.12.2020.
//

import UIKit
import SwiftyBeaver

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        if let window = window {
            appCoordinator = AppCoordinator(contentWindow: window)
            appCoordinator?.start()
        } else {
            fatalError("Должно быть окно")
        }

    }
}

extension SceneDelegate {
    public static func shared() -> SceneDelegate {
        
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        return sceneDelegate
    }
}

