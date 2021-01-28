//
//  SignInViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInDisplayLogic: class {
  func displayData(viewModel: SignIn.Model.ViewModel.ViewModelData)
}

class SignInViewController: UIViewController, SignInDisplayLogic {
    //MARK: - Controls
    private lazy var phoneNubmerView: InputPhoneNumberView = {
       let view = InputPhoneNumberView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton.getLittleRoundButton(text: "Подтвердить телефон")
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isEnabled = true
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.circeRegular(with: 17)
        button.setTitleColor(.mainTextColor(), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var interactor: SignInBusinessLogic?
    var router: (NSObjectProtocol & SignInRoutingLogic)?

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
        let interactor            = SignInInteractor()
        let presenter             = SignInPresenter()
        let router                = SignInRouter()
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
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Objc funcs
    @objc private func confirmButtonTapped() {
        print(#function)
        navigationController?.setupAsBaseScreen(self, animated: true)
        navigationController?.pushViewController(SMSConfirmViewController(), animated: true)
    }
    @objc private func signUpButtonTapped() {
        print(#function)
        let vc = SignUpViewController()
        navigationController?.setupAsBaseScreen(self, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
  
    func displayData(viewModel: SignIn.Model.ViewModel.ViewModelData) {

    }
    
    private func setupNavigationController() {
        navigationItem.title = "Войти"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationController?.navigationBar.isHidden = false
    }
}

//MARK: - Constraints
extension SignInViewController {
    private func setupConstraints() {
        view.addSubview(phoneNubmerView)
        view.addSubview(confirmButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            phoneNubmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            phoneNubmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
            phoneNubmerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            phoneNubmerView.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
            confirmButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

import SwiftUI

struct SignInVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let signInVC = SignInViewController()

        func makeUIViewController(context: Context) -> some SignInViewController {
            return signInVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
