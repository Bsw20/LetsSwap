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
import RealmSwift

protocol NotificationDisplayLogic: class {
  func displayData(viewModel: SwapNotification.Model.ViewModel.ViewModelData)
}

class NotificationViewController: UIViewController, NotificationDisplayLogic{
    typealias NotificationModel = SwapNotification.AllNotifications.ViewModel
    //MARK: - Controls
    private let collectionView: NotificationCollectionView = {
        var collectionView = NotificationCollectionView()
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         return collectionView
    }()
    
    var backgroundImageView: UIImageView!
    var backgroundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow()
        label.font = UIFont.circeRegular(with: 17)
        label.text = "Ждите ответов на свои предложения махнуться"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var interactor: NotificationBusinessLogic?
    var router: (NSObjectProtocol & NotificationRoutingLogic)?
    
    var service: Socket = Socket.shared

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
        
        let backgroundImage = UIImage.init(named: "presentationThirdImage")
        backgroundImageView = UIImageView.init(frame: self.view.frame)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .mainBackground()
        setupNavigation()
        collectionView.customDelegate = self
        setupConstraints()
        let savedNotifications = RealmManager.shared.loadNotifications()
        if !savedNotifications.offers.isEmpty {
            backgroundImageView.isHidden = true
            backgroundLabel.isHidden = true
            collectionView.updateData(notifications: savedNotifications)
        }
        
        
        service.listenForNotifications { (result) in
            switch result {
            
            case .success(_):
                self.getNotifications {[weak self] (result) in
                    print(#function)
                    switch result {
                    
                    case .success(let notifications):
                        if notifications.offers.isEmpty {
                            self?.collectionView.isHidden = true
                            self?.backgroundLabel.isHidden = false
                            self?.backgroundImageView.isHidden = false
                        } else {
                            self?.collectionView.isHidden = false
                            self?.backgroundLabel.isHidden = true
                            self?.backgroundImageView.isHidden = true
                            onMainThread {
                                self?.collectionView.updateData(notifications: notifications)
                                RealmManager.shared.saveNotifications(notifications: notifications)
                            }
                        }
                        
                    case .failure(let error):
                        SwiftyBeaver.error(error.localizedDescription)
                        UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
                    }
                }
            case .failure(_):
                self.getNotifications {[weak self] (result) in
                    print(#function)
                    switch result {
                    
                    case .success(let notifications):
                        onMainThread {
                            self?.collectionView.updateData(notifications: notifications)
                            RealmManager.shared.saveNotifications(notifications: notifications)
                        }
                    case .failure(let error):
                        SwiftyBeaver.error(error.localizedDescription)
                        UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotifications {[weak self] (result) in
            print(#function)
            switch result {
            
            case .success(let notifications):
                self?.updateBackgroundView(notifications: notifications)
                self?.collectionView.updateData(notifications: notifications)
                RealmManager.shared.saveNotifications(notifications: notifications)
            case .failure(let error):
                SwiftyBeaver.error(error.localizedDescription)
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
        
        
    }
    func getNotifications(completion: @escaping (Result<NotificationModel, Error>) -> Void) {
        guard let url = URL(string: "\(ServerAddressConstants.MAIN_SERVER_ADDRESS)/security/change/getNotifications") else {
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
  
    func displayData(viewModel: SwapNotification.Model.ViewModel.ViewModelData) {

    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = "Оповещения"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func updateBackgroundView(notifications: NotificationModel) {
        if notifications.offers.isEmpty {
            self.collectionView.isHidden = true
            self.backgroundImageView.isHidden = false
            self.backgroundLabel.isHidden = false
        } else {
            self.collectionView.isHidden = false
            self.backgroundImageView.isHidden = true
            self.backgroundLabel.isHidden = true
        }
    }
  
}

//MARK: - NotificationCollectionViewDelegate
extension NotificationViewController: NotificationCollectionViewDelegate {
    func routeToChat() {
        print("ROUTING TO CHAT NOT VC")
        UIApplication.showAlert(title: "Успешно!", message: "Чат создан!")
        getNotifications {[weak self] (result) in
            print(#function)
            switch result {
            
            case .success(let notifications):
                self?.updateBackgroundView(notifications: notifications)
                self?.collectionView.updateData(notifications: notifications)
                RealmManager.shared.saveNotifications(notifications: notifications)
            case .failure(let error):
                SwiftyBeaver.error(error.localizedDescription)
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        UIApplication.showAlert(title: title, message: message)
        getNotifications {[weak self] (result) in
            print(#function)
            switch result {
            
            case .success(let notifications):
                self?.updateBackgroundView(notifications: notifications)
                self?.collectionView.updateData(notifications: notifications)
                RealmManager.shared.saveNotifications(notifications: notifications)
            case .failure(let error):
                SwiftyBeaver.error(error.localizedDescription)
            }
        }
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
        
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130)
        ])
        
        self.view.addSubview(backgroundLabel)
        NSLayoutConstraint.activate([
            backgroundLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -18),
            backgroundLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
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

