//
//  NotificationViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyBeaver

protocol NotificationDisplayLogic: class {
  func displayData(viewModel: Notification.Model.ViewModel.ViewModelData)
}

class NotificationViewController: UIViewController, NotificationDisplayLogic{
    typealias NotificationModel = Notification.AllNotifications.ViewModel
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
        collectionView.customDelegate = self
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotifications {[weak self] (result) in
            print(#function)
            switch result {
            
            case .success(let notifications):
                self?.collectionView.updateData(notifications: notifications)
            case .failure(let error):
                SwiftyBeaver.error(error.localizedDescription)
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
        
        
    }
    func getNotifications(completion: @escaping (Result<NotificationModel, Error>) -> Void) {
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
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(NotificationModel.self, from: data)
//                        let model = data as? [String: Any]
//                        print(model)
                        completion(.success(model))
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

//MARK: - NotificationCollectionViewDelegate
extension NotificationViewController: NotificationCollectionViewDelegate {
    func routeToChat() {
        print("ROUTING TO CHAT NOT VC")
        UIApplication.showAlert(title: "Успешно!", message: "Чат создан!")
    }
    
    func showAlert(title: String, message: String) {
        UIApplication.showAlert(title: title, message: message)
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

