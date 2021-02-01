//
//  SignUpViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpDisplayLogic: class {
    func displayData(viewModel: SignUp.Model.ViewModel.ViewModelData)
}

class SignUpViewController: UIViewController, SignUpDisplayLogic {
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
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.circeRegular(with: 17)
        button.setTitleColor(.mainTextColor(), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private lazy var nameTextView: TextFieldView = TextFieldView(placeholder: "Имя")
    private lazy var lastNameTextView: TextFieldView = TextFieldView(placeholder: "Фамилия")
    
    private lazy var cityView: CityView = {
        let view = CityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Variables
    private let authService = AuthService()
    
    var router: (NSObjectProtocol & SignUpRoutingLogic)?

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
        let router                = SignUpRouter()

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
        setupActions()
        setupDelegates()
    }
    
    // MARK: Funcs
    private func collectData() -> SignUpViewModel {
        let phoneNumber = phoneNubmerView.getData().1.trimmingCharacters(in: .whitespaces)

        return SignUpViewModel(name: nameTextView.getText().trimmingCharacters(in: .whitespaces),
                               lastName: lastNameTextView.getText().trimmingCharacters(in: .whitespaces),
                               city: cityView.getCity().city,
                               login: "8" + phoneNumber,
                               smsCode: nil)
    }
    
    // MARK: Objc funcs
    @objc private func confirmButtonTapped() {
        print(#function)
        self.navigationController?.setupAsBaseScreen(self, animated: true)
        let signUpViewModel = collectData()
        print(signUpViewModel.representation)
        
        authService.sendSms(login: signUpViewModel.login) { (result) in
            switch(result) {

            case .success():
                print("sms sent")
                self.router?.routeToSMSScene(data: signUpViewModel)

            case .failure(let error):
                print("probs with sent sms")
                self.showAlert(title: "Ошибка, попробуйте позже!", message: error.localizedDescription)
            }
        }

    }
    
    
    @objc private func signInButtonTapped() {
        print(#function)
        navigationController?.setupAsBaseScreen(self, animated: true)
        let vc = SignInViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Funcs
    private func setupNavigationController() {
        navigationItem.title = "Регистрация"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black;
    }
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        nameTextView.delegate = self
        lastNameTextView.delegate = self
        cityView.delegate = self
        phoneNubmerView.delegate = self
    }
    
    private func confirmValidation() -> Bool{
        return !(nameTextView.isEmpty() || lastNameTextView.isEmpty() || phoneNubmerView.isEmpty())
    }
    func displayData(viewModel: SignUp.Model.ViewModel.ViewModelData) {

    }
}

//MARK: - InputPhoneNumberViewDelegate
extension SignUpViewController: InputPhoneNumberViewDelegate {
    func phoneNumberDidChange(newPhoneNumber: String) {
        if confirmValidation() {
            confirmButton.isEnabled = true
            return
        }
        confirmButton.isEnabled = false
    }
    
}

//MARK: - TextFieldViewDelegate
extension SignUpViewController: TextFieldViewDelegate {
    func textDidChange(textFieldView: TextFieldView, newText: String) {
        if confirmValidation() {
            confirmButton.isEnabled = true
            return
        }
        confirmButton.isEnabled = false
    }
}

//MARK: - CityViewDelegate
extension SignUpViewController: CityViewDelegate {
    func editButtonTapped(currentCity: City) {
        print("yes")
        router?.routeToCityListController(selectedCity: currentCity)
    }
}

//MARK: - CitiesListDelegate
extension SignUpViewController: CitiesListDelegate {
    func citySelected(city: City) {
        cityView.setCity(city: city)
    }
}

//MARK: - Constraints
extension SignUpViewController {
    private func setupConstraints() {
        view.addSubview(phoneNubmerView)
        view.addSubview(confirmButton)
        view.addSubview(signInButton)
        
        let topStackView = UIStackView.init(arrangedSubviews: [nameTextView, lastNameTextView, cityView], axis: .vertical, spacing: 8)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.backgroundColor = .clear
        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignUpConstants.leadingTrailingOffset),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignUpConstants.leadingTrailingOffset),
            topStackView.heightAnchor.constraint(equalToConstant: SignUpConstants.subviewsHeight * 3 + SignUpConstants.stackViewSpace * 2)
        ])
        
        NSLayoutConstraint.activate([
            phoneNubmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignUpConstants.leadingTrailingOffset),
            phoneNubmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignUpConstants.leadingTrailingOffset),
            phoneNubmerView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 10),
            phoneNubmerView.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignUpConstants.leadingTrailingOffset),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignUpConstants.leadingTrailingOffset),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            signInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignUpConstants.leadingTrailingOffset),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignUpConstants.leadingTrailingOffset),
            confirmButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
