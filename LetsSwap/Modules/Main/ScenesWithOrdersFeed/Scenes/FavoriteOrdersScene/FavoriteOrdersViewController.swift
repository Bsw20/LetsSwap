//
//  FavoriteOrdersViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import RealmSwift

protocol FavoriteOrdersDisplayLogic: class {
  func displayData(viewModel: FavoriteOrders.Model.ViewModel.ViewModelData)
}

class FavoriteOrdersViewController: UIViewController, FavoriteOrdersDisplayLogic {
    //MARK: - Variables
    private var feedCollectionView: FeedCollectionView
    var interactor: FavoriteOrdersBusinessLogic?
    var router: (NSObjectProtocol & FavoriteOrdersRoutingLogic)?

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feedCollectionView = FeedCollectionView(type: .withoutHeader)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init doesn't implemented")
    }
    
    var backgroundImageView: UIImageView!
    var backgroundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow()
        label.font = UIFont.circeRegular(with: 17)
        label.text = "Добавьте в избранные предложения на главной ленте"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
  
  // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = FavoriteOrdersInteractor()
        let presenter             = FavoriteOrdersPresenter()
        let router                = FavoriteOrdersRouter()
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
        
        let backgroundImage = UIImage.init(named: "favPlace")
        backgroundImageView = UIImageView.init(frame: self.view.frame)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.backgroundColor = .mainBackground()
        setupConstraints()
        setupNavigationController()
        feedCollectionView.customDelegate = self
        let favorites = RealmManager.shared.loadFavorites()
        if !favorites.cells.isEmpty {
            backgroundImageView.isHidden = true
            backgroundLabel.isHidden = true
            self.feedCollectionView.updateData(feedViewModel: favorites)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .getFeed)
    }
  
    func displayData(viewModel: FavoriteOrders.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            if feedViewModel.cells.isEmpty {
                self.feedCollectionView.isHidden = true
                self.backgroundImageView.isHidden = false
                self.backgroundLabel.isHidden = false
            } else {
                self.feedCollectionView.isHidden = false
                self.backgroundImageView.isHidden = true
                self.backgroundLabel.isHidden = true
                onMainThread {
                    self.feedCollectionView.updateData(feedViewModel: feedViewModel)
                    RealmManager.shared.saveFavorites(feedViewModel: feedViewModel)
                }
            }
            

        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        }
        view.isUserInteractionEnabled = true
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Закладки"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.isTranslucent = true
    }
}

//MARK: - FeedCollectionViewDelegate
extension FavoriteOrdersViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
        view.isUserInteractionEnabled = false
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    
    func showAlert(title: String, message: String) {
        UIViewController.showAlert(title: title, message: message)
    }
    
    func favouriteButtonTapped(newState: Bool) {
        interactor?.makeRequest(request: .getFeed)
    }
    func refresh() {
        interactor?.makeRequest(request: .getFeed)
    }
    
    
}
//MARK: - Constraints
extension FavoriteOrdersViewController {
    private func setupConstraints() {
        view.addSubview(feedCollectionView)

        feedCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130)
        ])
        
        self.view.addSubview(backgroundLabel)
        NSLayoutConstraint.activate([
            backgroundLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 80),
            backgroundLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
}
