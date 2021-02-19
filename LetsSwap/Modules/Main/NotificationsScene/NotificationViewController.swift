//
//  NotificationViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import Alamofire

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotifications { (result) in
            print(#function)
        }
        
        
    }
    func getNotifications(completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/change/getNotifications") else {
            completion(.failure(FeedError.serverError))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
//                        let model = try JSONDecoder().decode(FeedResponse.self, from: data)
                        let model = data as? [String: Any]
                        print(model)
//                        completion(.success(model))
                    } catch(let error){
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
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

