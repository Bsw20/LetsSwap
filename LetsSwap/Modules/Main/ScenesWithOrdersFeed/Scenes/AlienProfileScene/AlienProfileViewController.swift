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
}

class AlienProfileViewController: UIViewController, AlienProfileDisplayLogic {
    //variables
    private var userId: Int
    
    //Controls
    private var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var feedCollectionView: FeedCollectionView = {
        var collectionView = FeedCollectionView(type: .withoutHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
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
        print(userId)
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
        print("alien profile")
        view.backgroundColor = .mainBackground()

        setupConstraints()
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
//        topView.setup(swapsCount: 25, raiting: 3.5, imageView: nil)
        interactor?.makeRequest(request: .getProfile(userId: userId))
        feedCollectionView.customDelegate = self

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
        showAlert(title: title, message: message)
    }
}

//MARK: - Constraints
extension AlienProfileViewController {
    private func setupConstraints() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                        scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
//            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
        
        scrollView.addSubview(chatButton)
        scrollView.addSubview(topView)
        scrollView.addSubview(cityNameLabel)
        scrollView.addSubview(feedCollectionView)
//        scrollView.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AlienProfileConstants.topViewInset.right),
            chatButton.heightAnchor.constraint(equalToConstant: AlienProfileConstants.chatButtonHeight),
            chatButton.widthAnchor.constraint(equalToConstant: AlienProfileConstants.chatButtonHeight),
            chatButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AlienProfileConstants.topViewInset.top)
        ])
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: AlienProfileConstants.topViewInset.left),
            topView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AlienProfileConstants.topViewInset.top),
            topView.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -AlienProfileConstants.chatButtonLeadingOffset),
            topView.heightAnchor.constraint(equalToConstant: AlienProfileConstants.chatButtonHeight)
        ])

        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
            cityNameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        ])
        
        #warning("Уточнить нормально и точно высчитать высоту")
        //высота высчитывается на основе feedCollectionView размеров
        let first = (UIScreen.main.bounds.width * 0.6 - 40)
//        let second = CGFloat(NetworkDataFetcher.feedItems.count / 2 + 1)
        let second = CGFloat(700)
        let height =  first * second
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            feedCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            feedCollectionView.heightAnchor.constraint(equalToConstant: height),
            feedCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
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


