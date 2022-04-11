//
//  SignInViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021. All rights reserved.
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
        button.isEnabled = false
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
    
    private var authService = AuthService()
    
    var registerButtonConstaintToBottom: NSLayoutConstraint?
    var registerButtonConstaintToKeyboard: NSLayoutConstraint?
    
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
        let router                = SignInRouter()
        viewController.router     = router
        router.viewController     = viewController
    }
  
    // MARK: Routing
  

  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupConstraints()
        setupNavigationController()

        setupDelegates()
        setupActions()
        setupObservers()
        hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: - Objc funcs
    @objc private func confirmButtonTapped() {
        print(#function)
        navigationController?.setupAsBaseScreen(self, animated: true)
        let signInViewModel = collectData()
        authService.sendSms(login: signInViewModel.login) { (result) in
            switch(result) {

            case .success():
                self.router?.routeToSMSScene(data: signInViewModel)

            case .failure(let error):
                SignInViewController.showAlert(title: "Ошибка, попробуйте позже!", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        print(#function)
        let vc = SignUpViewController()
        navigationController?.setupAsBaseScreen(self, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if registerButtonConstaintToKeyboard == nil {
            if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                registerButtonConstaintToKeyboard = signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
            }
        }
        registerButtonConstaintToKeyboard?.isActive = true
        registerButtonConstaintToBottom?.isActive = false
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        registerButtonConstaintToKeyboard?.isActive = false
        registerButtonConstaintToBottom?.isActive = true
    }
    
    //MARK: - Funcs
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupDelegates() {
        phoneNubmerView.delegate = self
    }
    func displayData(viewModel: SignIn.Model.ViewModel.ViewModelData) {

    }
    
    private func collectData() -> SignInViewModel {
        let phoneNumber = phoneNubmerView.getData().1.trimmingCharacters(in: .whitespaces)

        return SignInViewModel(login: "8" + phoneNumber,
                               smsCode: nil)
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Войти"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func confirmValidation() -> Bool{
        return phoneNubmerView.numberLength() == 10
    }
}

//MARK: - InputPhoneNumberViewDelegate
extension SignInViewController: InputPhoneNumberViewDelegate {
    func phoneNumberDidChange(newPhoneNumber: String) {
        if confirmValidation() {
            confirmButton.isEnabled = true
            return
        }
        confirmButton.isEnabled = false
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
        
        registerButtonConstaintToBottom = signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        registerButtonConstaintToBottom?.isActive = true
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
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
