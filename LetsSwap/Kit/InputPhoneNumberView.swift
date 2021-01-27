//
//  InputPhoneNumberView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit


class InputPhoneNumberView: UIView {
    
    private lazy var countryCodeView: TextFieldView = {
       let view = TextFieldView(placeholder: "+7")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var phoneNumberView: TextFieldView = {
       let view = TextFieldView(placeholder: "Телефон")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var countryButton: PhoneCountryButton = {
        let button = PhoneCountryButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .clear
        countryButton.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func countryButtonTapped() {
        print(#function)
    }
}

//MARK: - Constraints
extension InputPhoneNumberView {
    private func setupConstraints() {
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .clear
        bottomView.addSubview(countryCodeView)
        bottomView.addSubview(phoneNumberView)
        
        NSLayoutConstraint.activate([
            countryCodeView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            countryCodeView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            countryCodeView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            countryCodeView.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.19)
        ])
        
        NSLayoutConstraint.activate([
            phoneNumberView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            phoneNumberView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            phoneNumberView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            phoneNumberView.leadingAnchor.constraint(equalTo: countryCodeView.trailingAnchor, constant: 8)
        ])
        
//        let mainStackView = UIStackView(arrangedSubviews: [countryButton, bottomView], axis: .vertical, spacing: 15)
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(mainStackView)
//
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: topAnchor),
//            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        
        addSubview(countryButton)
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            countryButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            countryButton.topAnchor.constraint(equalTo: topAnchor),
            countryButton.widthAnchor.constraint(equalToConstant: 160),
            countryButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.topAnchor.constraint(equalTo: countryButton.bottomAnchor, constant: 10),
            bottomView.widthAnchor.constraint(equalTo: widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
