//
//  MyProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol MyProfileDisplayLogic: class {
  func displayData(viewModel: MyProfile.Model.ViewModel.ViewModelData)
}

class MyProfileViewController: UIViewController, MyProfileDisplayLogic {
    //MARK: - Controls
    private lazy var feedCollectionView: MyProfileFeedCollectionView = {
       var collectionView = MyProfileFeedCollectionView()
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    //MARK: - Variables
    var interactor: MyProfileBusinessLogic?
    var router: (NSObjectProtocol & MyProfileRoutingLogic)?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        feedCollectionHeightAnchor.constraint(equalTo: feedCollectionView.heightAnchor).isActive = true
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
        let interactor            = MyProfileInteractor()
        let presenter             = MyProfilePresenter()
        let router                = MyProfileRouter()
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
        print("SVD")
        view.backgroundColor = .mainBackground()
        setupNavigationController()
        interactor?.makeRequest(request: .getWholeProfile)
         
        setupConstraints()
//        topView.setup(swapsCount: 23, raiting: 3.8, imageView: nil)
//        cityNameLabel.setup(name: "Митя Матвеев", city: "г. Москва")
        setupDelegates()
    }
    
    //MARK: - funcs
    private func setupDelegates() {
        feedCollectionView.myProfileDelegate = self
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Мой профиль"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(settingsButtonTapped)), animated: true)
    }
    
  
    func displayData(viewModel: MyProfile.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayWholeProfile(myProfileViewModel: let myProfileViewModel):
            feedCollectionView.updateData(feedViewModel: myProfileViewModel)
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayOrder(orderModel: let model):
            router?.routeToOpenOrder(orderModel: model)
        }

    }
    
    //MARK: - Objc funcs
    @objc private func settingsButtonTapped() {
        print("settings button tapped")
        router?.routeToEditScreen()
    }
  
  
}

//MARK: - MyProfileFeedCollectionViewDelegate
extension MyProfileViewController: MyProfileFeedCollectionViewDelegate {
    func createOrderCellTapped() {
        print("create order cell tapped")
        router?.routeToCreateOrder()
    }
    
    func openOrderCellTapped(orderId: Int) {
        print("open order cell tapped")
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    
    
}

//MARK: - Constraints
extension MyProfileViewController {
    private func setupConstraints() {
        view.addSubview(feedCollectionView)
        feedCollectionView.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MyProfileVCProvider: PreviewProvider {
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

