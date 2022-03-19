//
//  MyProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
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
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .green
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
    //MARK: - Variables
    var interactor: MyProfileBusinessLogic?
    var router: (NSObjectProtocol & MyProfileRoutingLogic)?
    private var needToBeUpdated: Bool = true

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
        view.backgroundColor = .mainBackground()
        setupNavigationController()
         
        setupConstraints()
//        topView.setup(swapsCount: 23, raiting: 3.8, imageView: nil)
//        cityNameLabel.setup(name: "Митя Матвеев", city: "г. Москва")
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if needToBeUpdated {
            interactor?.makeRequest(request: .getWholeProfile)
            needToBeUpdated = false
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSpinner()
    }
    
    //MARK: - funcs
    public func startSpinner() {
        spinner.startAnimating()
    }
   
    public func stopSpinner() {
        spinner.stopAnimating()
    }
    
    private func setupDelegates() {
        feedCollectionView.myProfileDelegate = self
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Мой профиль"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(settingsButtonTapped)), animated: true)
        navigationController?.navigationBar.isTranslucent = true
    }
    
  
    func displayData(viewModel: MyProfile.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayWholeProfile(myProfileViewModel: let myProfileViewModel):
            feedCollectionView.updateData(feedViewModel: myProfileViewModel)
            print("My profile image")
            print(myProfileViewModel.personInfo.profileImage)
        case .displayError(error: let error):
            MyProfileViewController.showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayOrder(orderModel: let model):
            router?.routeToOpenOrder(orderModel: model)
        case .displayFullProfileInfo(profileInfo: let model):
            router?.routeToEditScreen(model: model)
        }

    }
    
    //MARK: - Objc funcs
    @objc private func settingsButtonTapped() {
        interactor?.makeRequest(request: .getFullProfileInfo)
    }
  
  
}

//MARK: - MyProfileFeedCollectionViewDelegate
extension MyProfileViewController: MyProfileFeedCollectionViewDelegate {
    func createOrderCellTapped() {
        router?.routeToCreateOrder()
    }
    
    func openOrderCellTapped(orderId: Int) {
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
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

//MARK: - StateTrackerDelegate
extension MyProfileViewController: StateTrackerDelegate {
    func stateDidChange() {
        needToBeUpdated = true
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

