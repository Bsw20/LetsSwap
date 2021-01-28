//
//  SMSConfirmViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit

class SMSConfirmViewController: UIViewController {
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
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton.getLittleRoundButton(text: "Подтвердить")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Variables
    weak var authDelegate: AuthFinishedDelegate? = SceneDelegate.shared().appCoordinator
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupConstraints()
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Objc funcs
    
    @objc private func confirmButtonTapped() {
        print(#function)
        print(textView.getText())
        
        authDelegate?.authFinished()
    }
}

//MARK: - Constraints
extension SMSConfirmViewController {
    private func setupConstraints() {
        view.addSubview(topLabel)
        view.addSubview(textView)
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            textView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 30),
            textView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SignInConstants.leadingTrailingOffset),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SignInConstants.leadingTrailingOffset),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            confirmButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
