//
//  NotificationViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

protocol NotificationDisplayLogic: class {
  func displayData(viewModel: Notification.Model.ViewModel.ViewModelData)
}

class NotificationViewController: UIViewController, NotificationDisplayLogic{
    //MARK: - Controls
    private let collectionView: NotificationCollectionView = {
        var collectionView = NotificationCollectionView()
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         return collectionView
    }()

    var interactor: NotificationBusinessLogic?
    var router: (NSObjectProtocol & NotificationRoutingLogic)?

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
        let interactor            = NotificationInteractor()
        let presenter             = NotificationPresenter()
        let router                = NotificationRouter()
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
        view.backgroundColor = .mainBackground()
        setupNavigation()
        setupConstraints()
    }
  
    func displayData(viewModel: Notification.Model.ViewModel.ViewModelData) {

    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = "Оповещения"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
    }
  
}

//MARK: - Constraints
extension NotificationViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct NotificationVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notifVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return notifVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

