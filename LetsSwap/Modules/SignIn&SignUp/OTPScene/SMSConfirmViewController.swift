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
        view.backgroundColor = .mainBackground()
        setupConstraints()
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        numbersView.delegate = self
    }
    
    //MARK: - Objc funcs
    
    @objc private func confirmButtonTapped() {

//        print(#function)
//        print(textView.getText())
//
//        let model = SignUpViewModel(name: "Ярослав",
//                                    lastName: "Карпунькин",
//                                    city: "Москва",
//                                    login: "89858182278",
//                                    smsCode: textView.getText())
//
//        authService.signUp(signUpModel: model) { (result) in
//            print("RESULT FROM VC")
//            switch result {
//
//            case .success(_):
//                print("NICE")
//            case .failure(_):
//                print("ZVIZDEC")
//            }
//        }
        

    }
}


//MARK: - OTPDelegate
//ma token ["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MCwiaWF0IjoxNjEyMDEzNzIwfQ.xppDQuayBeLYIhH7oNkLiednNrqJkoDoM8Oz1ZUzcf0"]
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
                        self.authDelegate?.authFinished()
                    case .failure(_):
                        break
                    }
                }
                
            case .signUp(data: var data):
//                ["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsImlhdCI6MTYxMjA5NjQ2NH0.sfXLi1rDR-uGqnUSvH6zVaVtLTwOm8EMs7S_glAWwaQ"]
//                let isCorrectCode = numbersView.getOTP() == "111111"
//                if isCorrectCode {
//                    numbersView.finishEnterAnimation(colorForAnimation: .green, isCorrectCode: isCorrectCode)
//                } else {
//                    numbersView.finishEnterAnimation(colorForAnimation: .red, isCorrectCode: isCorrectCode)
//                }
                data.smsCode = numbersView.getOTP()
                authService.signUp(signUpModel: data) { (result) in
                    switch result {

                    case .success():
                        self.numbersView.finishEnterAnimation(colorForAnimation: .green, isCorrectCode: true)
                    case .failure(_):
                        self.numbersView.finishEnterAnimation(colorForAnimation: .green, isCorrectCode: false)
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
//        view.addSubview(textView)
        view.addSubview(confirmButton)
        view.addSubview(numbersView)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            textView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30),
//            textView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
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
