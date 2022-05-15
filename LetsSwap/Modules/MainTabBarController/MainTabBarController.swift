//
//  MainTabBarController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol MainTabBarDisplayLogic: class {
    func displayData(viewModel: MainTabBar.Model.ViewModel.ViewModelData)
}

class MainTabBarController: UITabBarController, MainTabBarDisplayLogic {

    var interactor: MainTabBarBusinessLogic?
    var router: (NSObjectProtocol & MainTabBarRoutingLogic)?
    private var socket: Socket?


    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = MainTabBarInteractor()
        let presenter             = MainTabBarPresenter()
        let router                = MainTabBarRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("TOKEN" + APIManager.getToken())
        socket = Socket.shared
        tabBar.isTranslucent = false
        UITabBar.appearance().backgroundColor = .mainBackground()
        UITabBar.appearance().barTintColor = .mainBackground()
        viewControllers = [
            
            generateNavigationController(rootViewController: FeedViewController(), unselectedImage: UIImage(named: "feedIconOff")!, selectedImage: UIImage(named: "feedIconOn")!),
            generateNavigationController(rootViewController: FavoriteOrdersViewController(), unselectedImage: UIImage(named: "tabBarIconOff")!, selectedImage: UIImage(named: "tabBarIconOn")!),
            generateNavigationController(rootViewController: ConversationsViewController(), unselectedImage: UIImage(named: "chatIconOff")!, selectedImage: UIImage(named: "chatIconOn")!),
            generateNavigationController(rootViewController: NotificationViewController(), unselectedImage: UIImage(named: "notificationIconOff")!, selectedImage: UIImage(named: "notificationIconOn")!),
                        generateNavigationController(rootViewController: MyProfileViewController(), unselectedImage: UIImage(named: "personIconOff")!, selectedImage: UIImage(named: "personIconOn")!)
            
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, unselectedImage: UIImage, selectedImage: UIImage) -> UIViewController {
        let navigationVC = StateTrackerManager.shared.generateNavigationController(viewController: rootViewController)
        navigationVC.tabBarItem.image = unselectedImage
        navigationVC.tabBarItem.selectedImage = selectedImage
        navigationVC.navigationBar.barTintColor = .mainBackground()
        navigationVC.navigationBar.isTranslucent = false
        return navigationVC
    }
  
    func displayData(viewModel: MainTabBar.Model.ViewModel.ViewModelData) {

    }
  
}


// MARK: - SwiftUI
import SwiftUI

struct MainVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

