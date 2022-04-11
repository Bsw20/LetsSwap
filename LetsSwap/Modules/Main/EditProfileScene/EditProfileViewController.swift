//
//  EditProfileViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit
import SnapKit


class EditProfileViewController: UIViewController {
    weak var trackerDelegate: StateTrackerDelegate?
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
        picker = ImagePicker(presentationController: self, delegate: self)
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
    private var logOutButton: UIButton = {
        let button = UIButton.getLittleRoundButton(backgroundColor: #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1), text: "Выйти", image: nil, font: .circeRegular(with: 17), textColor: .errorRed())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Variables
    private var viewModel: EditProfileViewModel
    private var networkService: EditProfileFetcher = UserAPIService.shared
    private lazy var picker: ImagePicker? = nil
    
    var router: (NSObjectProtocol & EditProfileRoutingLogic)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setData()
        setupNavigation()
        setupConstraints()

        setupDelegates()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextFields))
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
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
        addPhotoView.customDelegate = self
    }
    
    private func setData() {
        nameTextView.setText(newText: viewModel.name)
        lastNameTextView.setText(newText: viewModel.lastname)
        cityView.setProperty(property: viewModel.city)
        phoneView.setProperty(property: viewModel.login)
        addPhotoView.setPhoto(photoStringUrl: viewModel.url)
    }
    
    private func collectData() -> EditProfileViewModel {
        return EditProfileViewModel(name: nameTextView.getText(),
                                    lastname: lastNameTextView.getText(),
                                    city: cityView.getCurrentProperty(),
                                    login: phoneView.getCurrentProperty(),
                                    url: addPhotoView.getPhotoUrl())
    }
    
    private func setupNavigation() {
        navigationItem.title = "Редактирование профиля"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.tintColor = .mainTextColor()
        navigationController?.navigationBar.isTranslucent = true
        
        
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
    }
    
    
    
    
    //MARK: - Objc funcs
    @objc private func logOutButtonTapped() {
        APIManager.logOut()
    }
    @objc private func resignTextFields() {
        nameTextView.resignTextField()
        lastNameTextView.resignTextField()
    }
    
    @objc private func rightBarButtonTapped() {
        resignTextFields()
        let model =  collectData()
        networkService.updateProfileInfo(model: model) { (result) in
            switch result {
            
            case .success():
                onMainThread {
                    EditProfileViewController.showAlert(title: "Успешно", message: "Информация обновлена")
                    self.trackerDelegate?.stateDidChange()
                }
            case .failure(let error):
                onMainThread {
                    EditProfileViewController.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
        
    }
    
}

//MARK: - ImagePickerDelegate
extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        addPhotoView.setPhoto(image: image)
    }
    
    
}

//MARK: - AddPhotoViewDelegate
extension EditProfileViewController: AddPhotoViewDelegate {
    func addPhotoViewTapped(){
        picker?.present(from: view)
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
            router?.routeToCityListController(selectedCity: currentProperty)
        }
        if view == phoneView {
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
        
        view.addSubview(logOutButton)
        
        logOutButton.snp.makeConstraints { (make) in
            make.width.equalTo(bottomStackView.snp.width).multipliedBy(0.3353)
            make.height.equalTo(40)
            make.top.equalTo(bottomStackView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        

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
