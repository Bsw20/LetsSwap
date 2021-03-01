//
//  FavoriteOrdersViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 13.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

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
        view.backgroundColor = .mainBackground()
        setupConstraints()
        setupNavigationController()
        feedCollectionView.customDelegate = self
//        interactor?.makeRequest(request: .getFeed)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .getFeed)
    }
  
    func displayData(viewModel: FavoriteOrders.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            onMainThread {
                self.feedCollectionView.updateData(feedViewModel: feedViewModel)
            }

        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Закладки"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
    }
}

//MARK: - FeedCollectionViewDelegate
extension FavoriteOrdersViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
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
    }
}
