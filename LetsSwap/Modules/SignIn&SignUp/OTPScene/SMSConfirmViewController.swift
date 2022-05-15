//
//  SMSConfirmViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit

class SMSConfirmViewController: UIViewController {
    enum AuthType {
        case signIn(data: SignInViewModel)
        case signUp(data: SignUpViewModel)
    }
    //MARK: - Controls
    private lazy var topLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 22, text: "Введите проверочный код")
        return label
    }()
    
    private lazy var textView: TextFieldView = {
       let view = TextFieldView(placeholder: "Введите смс")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var numbersView: OTPStackView = OTPStackView()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton.getLittleRoundButton(text: "Подтвердить")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    //MARK: - Variables
    weak var authDelegate: AuthFinishedDelegate? = SceneDelegate.shared().appCoordinator
    private var authService = AuthService()
    private var authType: AuthType
    
    init(authType: AuthType) {
        self.authType = authType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.light
        view.backgroundColor = .mainBackground()
        setupConstraints()
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        navigationController?.navigationBar.tintColor = .mainTextColor()
        navigationController?.navigationBar.isTranslucent = true
        numbersView.delegate = self
    }
    
    //MARK: - Objc funcs
    
    @objc private func confirmButtonTapped() {
    }
}


//MARK: - OTPDelegate
extension SMSConfirmViewController: OTPDelegate {
    func animationWithCorrectCodeFinished() {
        self.authDelegate?.authFinished()
    }
    
    func didChangeValidity(isValid: Bool) {
        if isValid {
            switch authType {
            
            case .signIn(data: var data):
                data.smsCode = numbersView.getOTP()
                authService.signIn(signInModel: data) { (result) in
                    switch result {
                    case .success():
                        print("----------------")
                        print(result)
                        self.numbersView.finishEnterAnimation(colorForAnimation: .green, isCorrectCode: true)
                    case .failure(_):
                        self.numbersView.finishEnterAnimation(colorForAnimation: .red, isCorrectCode: false)
                        break
                    }
                }
                
            case .signUp(data: var data):
                data.smsCode = numbersView.getOTP()
                authService.signUp(signUpModel: data) { (result) in
                    switch result {

                    case .success():
                        self.numbersView.finishEnterAnimation(colorForAnimation: .green, isCorrectCode: true)
                    case .failure(_):
                        self.numbersView.finishEnterAnimation(colorForAnimation: .red, isCorrectCode: false)
                    }
                }
            }
        }
    }
}

//MARK: - Constraints
extension SMSConfirmViewController {
    private func setupConstraints() {
        view.addSubview(topLabel)
        view.addSubview(confirmButton)
        view.addSubview(numbersView)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            numbersView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30),
            numbersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numbersView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
