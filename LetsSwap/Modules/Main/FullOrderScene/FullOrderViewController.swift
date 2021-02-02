//
//  FullOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FullOrderDisplayLogic: class {
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData)
}

class FullOrderViewController: UIViewController, FullOrderDisplayLogic {

    var interactor: FullOrderBusinessLogic?
    var router: (NSObjectProtocol & FullOrderRoutingLogic)?
    
    private var photosCollectionView: PhotosCollectionView!
    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleTextView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Добавь название"
        tf.textContainerInset = UIEdgeInsets(top: 12, left: 25, bottom: 0, right: 18)
        return tf
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Добавь описание"
        return tf
    }()
    
    private lazy var counterOfferTextView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Напиши, что хочешь взамен"
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
    
    private lazy var addPhotoButton: UIButton = UIButton.getPickerButton()
    
//    private lazy var addVideoButton: UIButton = UIButton.getPickerButton()
    
    private lazy var addVideoButton: UIButton = UIButton.getPickerButton()

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
//        OrderViewModel(order: OrderViewModel.Order.init(title: "123", description: "123", counterOffer: "123", isFree: true, tags: [], photoAttachments: [URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!]), user: OrderViewModel.User(userName: "123", userLastName: "123", userCity: "123", userPhoto: nil), orderId: 123, userId: 123)
        
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        photosCollectionView = PhotosCollectionView(photoAttachments: [URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,
                                                                       URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!] )
        setupConstraints()
        setupNavigation()

        
        chooseTagsView.coverButton.addTarget(self, action: #selector(chooseTagsButtonTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        addVideoButton.addTarget(self, action: #selector(addVideoButtonTapped), for: .touchUpInside)
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        counterOfferTextView.delegate = self
        photosCollectionView.photosDelegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideTextView))
        self.view.addGestureRecognizer(recognizer)

        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        freeSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        //threeLinesIcon
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = "Новое предложение"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(image: UIImage(named: "threeLinesIcon"), style: .plain, target: self, action: #selector(rightBarButtonTapped)), animated: true)
    }
    
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData) {

    }
    
    @objc private func switchValueDidChange() {
        #warning("Поменять модель")
        if freeSwitch.isOn {
            print("on")
            counterOfferTextView.backgroundColor = .freeFeedCell()
        } else {
            print("off")
            counterOfferTextView.backgroundColor = .white
        }
    }
    @objc private func rightBarButtonTapped() {
        print("right bar button tapped")
    }
    
    @objc private func chooseTagsButtonTapped() {
        print("choose tags button tapped")
        navigationController?.pushViewController(TagsListViewController(), animated: true)
    }
    
    @objc private func addPhotoButtonTapped() {
        print("add photo picker")
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

//MARK: - PhotosCollectionViewDelegate
extension FullOrderViewController: PhotosCollectionViewDelegate {
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
        contentView.addSubview(addPhotoButton)
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
            addPhotoButton.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: FullOrderConstants.labelPickerSpace),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 80),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 78),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            videoLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: FullOrderConstants.space),
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
        
        NSLayoutConstraint.activate([
            photosCollectionView.heightAnchor.constraint(equalToConstant: FullOrderConstants.photosCollectionViewSize.height),
            photosCollectionView.leadingAnchor.constraint(equalTo: addPhotoButton.trailingAnchor, constant: 20),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: addPhotoButton.topAnchor)
            
        ])
        
    }
}


// MARK: - TextViewDelegate
extension FullOrderViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == CommentConstants.textViewTextColor {
            textView.text = nil
                textView.textColor = UIColor.black
        }
        print("did begin")
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = CommentConstants.textViewTextColor
            print("is empty")
            if textView == titleTextView {
                textView.text = "Добавь название"
            } else if textView == descriptionTextView {
                textView.text = "Добавь описание"
            } else if textView == counterOfferTextView {
                textView.text = "Напиши, что хочешь взамен"
            }
        }
    }
    #warning("TODO")
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.isEmpty || textView.text == stringPlaceholder {
//            swapButton.isEnabled = false
//        } else {
//            swapButton.isEnabled = true
//        }
//    }
    
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

