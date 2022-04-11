//
//  AlienProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol AlienProfileDisplayLogic: class {
  func displayData(viewModel: AlienProfile.Model.ViewModel.ViewModelData)
    func displayFullModel(viewModel: AlienProfile.FullModel.ViewModel)
}

class AlienProfileViewController: UIViewController, AlienProfileDisplayLogic {

    
    //variables
    private var userId: Int
    private var needToBeUpdated: Bool = true
    
    //Controls
    
    private lazy var feedCollectionView: FeedCollectionView = {
        var collectionView = FeedCollectionView(type: .withoutHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    private lazy var topView: ProfileTopView = {
//        let view = ProfileTopView(topViewModel: ProfileTopViewModel(profileImage: nil, swapsCount: 5, rating: 4.5))
        let view = ProfileTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chatButton: UIButton = {
        let button = UIButton.roundButton(backgroundColor: .mainDetailsYellow(), image: UIImage(named: "chatImage"), cornerRadius: AlienProfileConstants.chatButtonHeight / 2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainBackground()
        return view
    }()
    
    private lazy var cityNameLabel: NameCityLabel = {
        let label = NameCityLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        return label
    }()
    
    var interactor: AlienProfileBusinessLogic?
    var router: (NSObjectProtocol & AlienProfileRoutingLogic)?

    // MARK: Object lifecycle
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = AlienProfileInteractor()
        let presenter             = AlienProfilePresenter()
        let router                = AlienProfileRouter()
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
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
//        topView.setup(swapsCount: 25, raiting: 3.5, imageView: nil)

        feedCollectionView.customDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor?.getFullModel(request: .init(userId: userId))
//        needToBeUpdated = false
    }
    

  
    func displayData(viewModel: AlienProfile.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayFullProfile(profileViewModel: let profileViewModel):
            feedCollectionView.updateData(feedViewModel: profileViewModel.feedViewModel)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
    
    func displayFullModel(viewModel: AlienProfile.FullModel.ViewModel) {
        print(#function)
        let feedViewModel = FeedViewModel.init(cells: viewModel.model.feedInfo.map{
            return FeedViewModel.Cell.init(orderId: $0.orderId,
                                           title: $0.title,
                                           description: $0.description,
                                           counterOffer: $0.counterOffer,
                                           photo: $0.photo == nil ? nil : URL(string: $0.photo!),
                                           isFavourite: $0.isFavorite,
                                           isFree: $0.isFree)
        })
        feedCollectionView.updateData(feedViewModel: feedViewModel)
        let personInfo = viewModel.model.personInfo
        cityNameLabel.setup(name: String.username(name: personInfo.name, lastname: personInfo.lastname), city: personInfo.cityName)
        topView.setup(swapsCount: personInfo.swapsCount, raiting: personInfo.raiting, image: viewModel.model.personInfo.profileImage)
    }
    
    
    @objc private func chatButtonTapped() {
        print(#function)
    }
}

//MARK: - FeedCollectionViewDelegate
extension AlienProfileViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    func showAlert(title: String, message: String) {
        UIApplication.showAlert(title: title, message: message)
    }
    
    func refresh() {
//        interactor?.makeRequest(request: .getOrder(orderId: orderId))
        interactor?.getFullModel(request: .init(userId: userId))
    }
    
    
}

//MARK: - Constraints
extension AlienProfileViewController {
    private func setupConstraints() {
        
        
        view.addSubview(chatButton)
        view.addSubview(topView)
        view.addSubview(cityNameLabel)
        view.addSubview(feedCollectionView)
        
        NSLayoutConstraint.activate([
            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AlienProfileConstants.topViewInset.right),
            chatButton.heightAnchor.constraint(equalToConstant: AlienProfileConstants.chatButtonHeight),
            chatButton.widthAnchor.constraint(equalToConstant: AlienProfileConstants.chatButtonHeight),
            chatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AlienProfileConstants.topViewInset.top)
        ])
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AlienProfileConstants.topViewInset.left),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AlienProfileConstants.topViewInset.top),
            topView.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -AlienProfileConstants.chatButtonLeadingOffset)
        ])

        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
            cityNameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - StateTrackerDelegate
extension AlienProfileViewController: StateTrackerDelegate {
    func stateDidChange() {
        needToBeUpdated = true
    }
    
    
}
// MARK: - SwiftUI
import SwiftUI

struct AlienProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let alienProfileVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return alienProfileVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}


