//
//  MyProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfileDisplayLogic: class {
  func displayData(viewModel: MyProfile.Model.ViewModel.ViewModelData)
}

class MyProfileViewController: UIViewController, MyProfileDisplayLogic {
    
    //Controls
    private lazy var topView: ProfileTopView = {
        let view = ProfileTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var cityNameLabel: NameCityLabel = {
        let label = NameCityLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var videoLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = .mainTextColor()
        label.text = "Мои видеопослания"
        return label
    }()
    
    var interactor: MyProfileBusinessLogic?
    var router: (NSObjectProtocol & MyProfileRoutingLogic)?

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
        navigationController?.navigationBar.topItem?.title = "Мой профиль"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(image: UIImage(named: "settingsIcon"), style: .plain, target: self, action: #selector(settingsButtonTapped)), animated: true)
         
        setupConstraints()
        topView.setup(swapsCount: 23, raiting: 3.8, imageView: nil)
        cityNameLabel.setup(name: "Митя Матвеев", city: "г. Москва")
    }
    
    @objc private func settingsButtonTapped() {
        print("settings button tapped")
    }
  
    func displayData(viewModel: MyProfile.Model.ViewModel.ViewModelData) {

    }
  
}

//Constraints
extension MyProfileViewController {
    private func setupConstraints() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(topView)
        scrollView.addSubview(cityNameLabel)
        scrollView.addSubview(videoLabel)
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: MyProfileConstants.topViewInset.left),
            topView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: MyProfileConstants.topViewInset.top),
            topView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -MyProfileConstants.topViewInset.left - MyProfileConstants.topViewInset.right),
            topView.heightAnchor.constraint(equalToConstant: MyProfileConstants.topViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
            cityNameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            videoLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 15),
            videoLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        ])
        
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

