//
//  FullOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FullOrderDisplayLogic: class {
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData)
}

class FullOrderViewController: UIViewController, FullOrderDisplayLogic {
    enum OperationType {
        case edit(model: FullOrderViewModel)
        case create
    }
    
    //MARK: - Variables
    var interactor: FullOrderBusinessLogic?
    var router: FullOrderRoutingLogic?
    var operationType: OperationType
    
    private var service: FullOrderFetcher = UserAPIService.shared
    
    //MARK: - Controls
    private var photosCollectionView: PhotosCollectionView = PhotosCollectionView()
    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleTextView: PlaceholderTextView = {
        let tf = PlaceholderTextView(placeholder: "Добавь название")
        tf.textContainerInset = UIEdgeInsets(top: 12, left: 25, bottom: 0, right: 18)
        return tf
    }()
    
    private lazy var descriptionTextView: PlaceholderTextView = {
        let tf = PlaceholderTextView(placeholder: "Добавь описание")
        return tf
    }()
    
    private lazy var counterOfferTextView: PlaceholderTextView = {
        let tf = PlaceholderTextView(placeholder: "Напиши, что хочешь взамен")
        return tf
    }()
    
    private lazy var freeOfferLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 17, text: "Готов реализовать предложение безвозмездно")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var freeSwitch: UISwitch = {
       let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.onTintColor = .mainDetailsYellow()
        return sw
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var yellowButton: UIButton = {
        let button = UIButton.getSwapButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chooseTagsView: ChooseTagsView = {
        let view = ChooseTagsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomEmptyView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var photoLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 17, text: "Добавь фото")
        return label
    }()
    
    private lazy var videoLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 17, text: "Добавь видео")
        return label
    }()
    
    private lazy var addVideoButton: UIButton = UIButton.getPickerButton()

  // MARK: Object lifecycle
  
    
    init(type: OperationType) {
        self.operationType = type
        super.init(nibName: nil, bundle: nil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("it isn't implemented")
    }
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = FullOrderInteractor()
        let presenter             = FullOrderPresenter()
        let router                = FullOrderRouter()
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
        setupNavigation()
        setupActions()
        setupDelegates()
        customizeElements()
        setupData()
        validateConfirmation()
    }
    
    //MARK: - funcs
    private func setupData() {
        switch operationType {
        
        case .edit(model: let model):
            titleTextView.setText(text: model.title)
            descriptionTextView.setText(text: model.description)
            counterOfferTextView.setText(text: model.counterOffer)
            freeSwitch.setOn(model.isFree, animated: false)
            switchValueDidChange()
            chooseTagsView.set(selectedTags: model.tags.compactMap{FeedTag.init(rawValue: $0)})
            photosCollectionView.set(photoAttachments: model.photoAttachments)
        case .create:
            break
        }
    }
    private func validateConfirmation() {
        let validate =  !(titleTextView.isEmpty || descriptionTextView.isEmpty || counterOfferTextView.isEmpty || chooseTagsView.isEmpty)
        yellowButton.isEnabled = validate
    }

    private func setupActions() {
        chooseTagsView.coverButton.addTarget(self, action: #selector(chooseTagsButtonTapped), for: .touchUpInside)
        addVideoButton.addTarget(self, action: #selector(addVideoButtonTapped), for: .touchUpInside)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideTextView))
        self.view.addGestureRecognizer(recognizer)
        
        freeSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        yellowButton.addTarget(self, action: #selector(yellowButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegates() {
        titleTextView.customDelegate = self
        descriptionTextView.customDelegate = self
        counterOfferTextView.customDelegate = self
        photosCollectionView.photosDelegate = self
        
    }
    
    private func customizeElements() {
        switch operationType {
        
        case .edit(model: _):
            yellowButton.setTitle("Сохранить", for: .normal)
            //TODO: setTags to tags view
        case .create:
            yellowButton.setTitle("Создать", for: .normal)
        }
    }
    
    private func setupNavigation() {
        switch operationType {
        
        case .edit(model: _):
            navigationItem.title = "Редактировать предложение"
        case .create:
            navigationItem.title = "Новое предложение"
        }

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.tintColor = .mainTextColor()
        
    }
    
    private func collectData() -> FullOrderViewModel {
        let model: FullOrderViewModel =
            FullOrderViewModel(title: titleTextView.getText().trimmingCharacters(in: .whitespaces),
                                       description: descriptionTextView.getText().trimmingCharacters(in: .whitespaces),
                                       isFree: freeSwitch.isOn,
                                       counterOffer: counterOfferTextView.getText().trimmingCharacters(in: .whitespaces),
                                       tags: (Array(chooseTagsView.getTags())).map{$0.rawValue
                                       },
                                       photoAttachments: photosCollectionView.getPhotos())
        return model
    }
    
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData) {

    }
    
    
    //MARK: - Objc func
    @objc private func yellowButtonTapped() {
        tapOutsideTextView()
        switch operationType {
        
        case .edit(model: let model):
            print(#function)
            print(model)
        case .create:
            let data = collectData()
            print(data)
            service.createOrder(model: data) { (result) in
                switch result {
                    
                case .success():
                    onMainThread {
                        self.showAlert(title: "Успешно", message: "Предложение создано") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    onMainThread {
                        self.showAlert(title: "Ошибка!", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc private func switchValueDidChange() {
        if freeSwitch.isOn {
            print("on")
            counterOfferTextView.backgroundColor = .freeFeedCell()
        } else {
            print("off")
            counterOfferTextView.backgroundColor = .white
        }
    }

    
    @objc private func chooseTagsButtonTapped() {
        print("choose tags button tapped")
        router?.routeToTagsList(selectedTags: Set(chooseTagsView.getTags()))
    }
    
    
    @objc private func addVideoButtonTapped() {
        print("add video picker")
    }
    
    
    @objc private func tapOutsideTextView() {
        titleTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        counterOfferTextView.resignFirstResponder()
    }
}

//MARK: - TagsListDelegate
extension FullOrderViewController: TagsListDelegate {
    func selectedTagsChanged(selectedTags: [FeedTag]) {
        chooseTagsView.set(selectedTags: selectedTags)
        validateConfirmation()
    }
    
}

//MARK: - PlaceholderTextViewDelegate
extension FullOrderViewController: PlaceholderTextViewDelegate {
    func textDidChange(view: PlaceholderTextView, newText: String) {
        validateConfirmation()
    }
}

extension FullOrderViewController: ImagePickerDelegate  {
    func didSelect(image: UIImage?) {
        if let image = image {
            print("Image got")
        } else {
            print("image didnt get")
        }

    }
    
    
}
//MARK: - PhotosCollectionViewDelegate
extension FullOrderViewController: PhotosCollectionViewDelegate  {
    func addPhotoButtonTapped() {
//        let picker = ImagePicker(presentationController: self, delegate: self)
//        picker.present(from: UIView())
        service.uploadImage(image: #imageLiteral(resourceName: "hand")) { (result) in
            
        }
    }
    
    func photosCollectionViewSize() -> CGSize {
        return FullOrderConstants.photosCollectionViewSize
    }
}



//MARK: - Constraints
extension FullOrderViewController {
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FullOrderConstants.leadingTrailingViewOffset),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FullOrderConstants.leadingTrailingViewOffset)
        ])
        
        scrollView.addSubview(contentView)
//        contentView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * FullOrderConstants.leadingTrailingViewOffset),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        contentView.addSubview(titleTextView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(counterOfferTextView)
        contentView.addSubview(freeOfferLabel)
        contentView.addSubview(freeSwitch)
        contentView.addSubview(yellowButton)
        contentView.addSubview(chooseTagsView)
        contentView.addSubview(bottomEmptyView)
        contentView.addSubview(photoLabel)
        contentView.addSubview(videoLabel)
        contentView.addSubview(addVideoButton)
        contentView.addSubview(photosCollectionView)
        
        
        
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: FullOrderConstants.space),
            titleTextView.heightAnchor.constraint(equalToConstant: FullOrderConstants.titleViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: FullOrderConstants.space),
            descriptionTextView.heightAnchor.constraint(equalToConstant: FullOrderConstants.descriptinViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            counterOfferTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            counterOfferTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            counterOfferTextView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: FullOrderConstants.space),
            counterOfferTextView.heightAnchor.constraint(equalToConstant: FullOrderConstants.counterOfferViewHeight)
        ])
        
        
        NSLayoutConstraint.activate([
            freeSwitch.topAnchor.constraint(equalTo: counterOfferTextView.bottomAnchor, constant: FullOrderConstants.space + 10),
            freeSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            freeOfferLabel.topAnchor.constraint(equalTo: counterOfferTextView.bottomAnchor, constant: FullOrderConstants.space),
            freeOfferLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            freeOfferLabel.trailingAnchor.constraint(equalTo: freeSwitch.leadingAnchor, constant: -20)

        ])
        
        NSLayoutConstraint.activate([
            chooseTagsView.topAnchor.constraint(equalTo: freeOfferLabel.bottomAnchor, constant: FullOrderConstants.space),
            chooseTagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chooseTagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chooseTagsView.heightAnchor.constraint(equalToConstant: FullOrderConstants.chooseTagsButtonHeight),
        ])
        


        
        NSLayoutConstraint.activate([
            photoLabel.topAnchor.constraint(equalTo: chooseTagsView.bottomAnchor, constant: FullOrderConstants.space),
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            photosCollectionView.heightAnchor.constraint(equalToConstant: FullOrderConstants.photosCollectionViewSize.height),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            videoLabel.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: FullOrderConstants.space),
            videoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addVideoButton.topAnchor.constraint(equalTo: videoLabel.bottomAnchor, constant: FullOrderConstants.labelPickerSpace),
            addVideoButton.heightAnchor.constraint(equalToConstant: 80),
            addVideoButton.widthAnchor.constraint(equalToConstant: 78),
            addVideoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            yellowButton.topAnchor.constraint(equalTo: addVideoButton.bottomAnchor, constant: FullOrderConstants.space),
            yellowButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yellowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yellowButton.heightAnchor.constraint(equalToConstant: FullOrderConstants.yellowButtonHeight)
        ])
        
        NSLayoutConstraint.activate([
            bottomEmptyView.heightAnchor.constraint(equalToConstant: 30),
            bottomEmptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomEmptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomEmptyView.topAnchor.constraint(equalTo: yellowButton.bottomAnchor),
            bottomEmptyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
        

        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct FullOrderVCProvider: PreviewProvider {
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

