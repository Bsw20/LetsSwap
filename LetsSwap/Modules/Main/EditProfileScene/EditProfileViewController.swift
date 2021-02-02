//
//  EditProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit



class EditProfileViewController: UIViewController {
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Controls
    private lazy var nameTextView: TextFieldView = TextFieldView(placeholder: "Имя")
    private lazy var lastNameTextView: TextFieldView = TextFieldView(placeholder: "Фамилия")
    
    private lazy var cityView: ChangePropertyView = {
        let view = ChangePropertyView(propertyType: .city(data: City.getCities()[0]))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var phoneView: ChangePropertyView = ChangePropertyView(propertyType: .phoneNumber(data: ""))
    
    private lazy var addPhotoView: AddPhotoView = {
        let view = AddPhotoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var applyBarButton: UIBarButtonItem!
    
    //MARK: - Variables
    private var viewModel: EditProfileViewModel
    private var networkService: EditProfileFetcher = UserAPIService.shared
    
    var router: (NSObjectProtocol & EditProfileRoutingLogic)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setData()
        setupNavigation()
        setupConstraints()

        setupDelegates()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextFields))
        self.view.addGestureRecognizer(recognizer)
    }
    
    //MARK: - Funcs
    
    private func setup() {
        let viewController        = self
        let router                = EditProfileRouter()

        viewController.router     = router
        router.viewController     = viewController
    }
    
    private func setupDelegates() {
        phoneView.delegate = self
        cityView.delegate = self
        nameTextView.delegate = self
        lastNameTextView.delegate = self
    }
    
    private func setData() {
        nameTextView.setText(newText: viewModel.name)
        lastNameTextView.setText(newText: viewModel.lastname)
        cityView.setProperty(property: viewModel.city)
        phoneView.setProperty(property: viewModel.phoneNumber)
        addPhotoView.setPhoto(photoStringUrl: viewModel.imageStringUrl)
    }
    
    private func collectData() -> EditProfileViewModel {
        return EditProfileViewModel(name: nameTextView.getText(),
                                    lastname: lastNameTextView.getText(),
                                    city: cityView.getCurrentProperty(),
                                    phoneNumber: phoneView.getCurrentProperty(),
                                    imageStringUrl: nil)
    }
    
    private func setupNavigation() {
        navigationItem.title = "Редактирование профиля"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        
        applyBarButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        applyBarButton = UIBarButtonItem.getTappableButton(
            target: self,
            action: #selector(rightBarButtonTapped),
            enabledImage: UIImage(named: "tick"),
            disabledImage: (UIImage(named: "unselectedTick")),
            isEnabled: true)
        navigationItem.setRightBarButton(applyBarButton, animated: true)
        trackApplyButtonState()
    }
    
    private func confirmValidation() -> Bool{
        return !(nameTextView.isEmpty() || lastNameTextView.isEmpty())
    }
    
    private func trackApplyButtonState() {
        if confirmValidation() {
            applyBarButton.isEnabled = true
            return
        }
        applyBarButton.isEnabled = false
        print("why here")
    }
    
    
    
    
    //MARK: - Objc funcs
    @objc private func resignTextFields() {
        nameTextView.resignTextField()
        lastNameTextView.resignTextField()
    }
    
    @objc private func rightBarButtonTapped() {
        print("right bar button tapped")
        resignTextFields()
        let model =  collectData()
        print(model)
        networkService.updateProfileInfo(model: model) { (result) in
            switch result {
            
            case .success():
                onMainThread {
                    self.showAlert(title: "Успешно", message: "Информация обновлена")
                }
            case .failure(let error):
                onMainThread {
                    self.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
        
    }
    
}

//MARK: - TextFieldViewDelegate
extension EditProfileViewController: TextFieldViewDelegate {
    func textDidChange(textFieldView: TextFieldView, newText: String) {
        trackApplyButtonState()
    }
}

//MARK: - CitiesListDelegate
extension EditProfileViewController: CitiesListDelegate {
    func citySelected(city: String) {
        cityView.setProperty(property: city)
    }
}

//MARK: - ChangePropertyViewDelegate
extension EditProfileViewController: ChangePropertyViewDelegate {
    func editButtonTapped(view: ChangePropertyView, currentProperty: String) {
        if view == cityView {
            print("cityView")
            router?.routeToCityListController(selectedCity: currentProperty)
        }
        if view == phoneView {
            print("PhoneView")
        }
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
        
        let bottomStackView = UIStackView.init(arrangedSubviews: [phoneView], axis: .vertical, spacing: 8)
        
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
