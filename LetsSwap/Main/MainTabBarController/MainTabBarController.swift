//
//  MainTabBarController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainTabBarDisplayLogic: class {
    func displayData(viewModel: MainTabBar.Model.ViewModel.ViewModelData)
}

class MainTabBarController: UITabBarController, MainTabBarDisplayLogic {

    var interactor: MainTabBarBusinessLogic?
    var router: (NSObjectProtocol & MainTabBarRoutingLogic)?

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
        viewControllers = [
//            generateNavigationController(rootViewController: FeedViewController(), image: UIImage(named: "feedIcon")!)
            generateNavigationController(rootViewController: FeedOrderViewController(), image: UIImage(named: "feedIcon")!)
        ]
        
    }
    
    private func generateNavigationController(rootViewController: UIViewController, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
  
    func displayData(viewModel: MainTabBar.Model.ViewModel.ViewModelData) {

    }
  
}
