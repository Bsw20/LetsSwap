//
//  EditProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit



class EditProfileViewController: UIViewController {
    
    private lazy var nameTextView: TextFieldView = TextFieldView(placeholder: "Имя")
    private lazy var lastNameTextView: TextFieldView = TextFieldView(placeholder: "Фамилия")
    
    private lazy var cityView: ChangePropertyView = {
        let view = ChangePropertyView(propertyType: .city(data: City.getCities()[0]))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var phoneTextView: TextFieldView = TextFieldView(placeholder: "Телефон")
    
    private lazy var addPhotoView: AddPhotoView = {
        let view = AddPhotoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupNavigation()
        setupConstraints()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextFields))
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func setupNavigation() {
        navigationItem.title = "Редактирование профиля"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "tick"), style: .plain, target: self, action: #selector(rightBarButtonTapped)), animated: true)
    }
    
    @objc private func resignTextFields() {
        nameTextView.resignTextField()
        lastNameTextView.resignTextField()
        phoneTextView.resignTextField()
    }
    
    @objc private func rightBarButtonTapped() {
        print("right bar button tapped")
    }
    
}

//MARK: - TextField
extension EditProfileViewController {
    private func setupConstraints() {
        view.addSubview(addPhotoView)
        NSLayoutConstraint.activate([
            addPhotoView.widthAnchor.constraint(equalToConstant: EditProfileConstants.addPhotoViewSize.width),
            addPhotoView.heightAnchor.constraint(equalToConstant: EditProfileConstants.addPhotoViewSize.height),
            addPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let topStackView = UIStackView.init(arrangedSubviews: [nameTextView, lastNameTextView, cityView], axis: .vertical, spacing: 8)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.backgroundColor = .clear
        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 26),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: EditProfileConstants.leadingOffset),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: EditProfileConstants.trailingInset),
            topStackView.heightAnchor.constraint(equalToConstant: EditProfileConstants.subviewsHeight * 3 + EditProfileConstants.stackViewSpace * 2)
        ])
        
        let bottomStackView = UIStackView.init(arrangedSubviews: [phoneTextView], axis: .vertical, spacing: 8)
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: EditProfileConstants.leadingOffset),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: EditProfileConstants.trailingInset),
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
            bottomStackView.heightAnchor.constraint(equalToConstant: EditProfileConstants.subviewsHeight)
        ])
        

    }
}

// MARK: - SwiftUI
import SwiftUI

struct EditProfileVCProvider: PreviewProvider {
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
