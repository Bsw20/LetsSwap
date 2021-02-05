//
//  FeedOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol FeedOrderDisplayLogic: class {
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData)
}

protocol FeedOrderRepresentableModel {
    var order: OrderRepresentableViewModel { get }
    var user: UserRepresentableViewModel { get }
}

protocol OrderRepresentableViewModel {

    var title: String { get }
    var description: String { get }
    var counterOffer: String { get }
    var isFree: Bool { get }
    var tags: [FeedTag] { get }
    var photoAttachments: [URL]{ get }
}
protocol UserRepresentableViewModel {
    var userName: String { get }
    var userLastName: String { get }
    var userCity: String { get}
    var userPhoto: URL? { get }
}

class FeedOrderViewController: UIViewController, FeedOrderDisplayLogic {

    //MARK: - variables
    private var type: FeedOrderType
    private var orderViewModel: OrderRepresentableViewModel
    var interactor: FeedOrderBusinessLogic?
    var router: (NSObjectProtocol & FeedOrderRoutingLogic)?
    
    //MARK: - controls
    private var photosCollectionView: PhotosCarouselCollectionView!
    private var tagsCollectionView: TagsCollectionView!
    
    private var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private var topView: OrderTitleView = {
       let view = OrderTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true

        return view
    }()
    
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Делаю необычные тату"
        label.numberOfLines = 4
        label.font = UIFont.circeRegular(with: 34)
        label.textColor = FeedOrderConstants.mainTextColor
        return label
    }()
    
    private var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ищу моделей для своего портфолио в инстаграм. Можете посмотреть уже готовые работы @okxytatt"
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = FeedOrderConstants.mainTextColor
        label.numberOfLines = 3
        return label
    }()
    
    private var wantSwapLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Хочу махнуться на \u{27a9}"
        label.font = UIFont.circeBold(with: 16)
        label.textColor = FeedOrderConstants.mainTextColor
        return label
    }()
    
    private var counterOfferLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Я бы хотела научиться читать рэп или взять пару уроков по битбоксу."
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = FeedOrderConstants.mainTextColor
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var freeSwapLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Готов реализовать предложение безвозмездно"
        label.textColor = #colorLiteral(red: 0.8666666667, green: 0.7098039216, blue: 0.2352941176, alpha: 1)
        label.font = UIFont.circeBold(with: 15)
        return label
    }()
    
    private lazy var swapButton: UIButton = {
        let button = LittleRoundButton.newButton(backgroundColor: .mainYellow(), text: "Махнуться", image: nil, font: .circeRegular(with: 22), textColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editOrderButton: UIButton = UIButton.getLittleRoundButton(backgroundColor: .detailsGrey(), text: "Редактировать предложение", image: nil, font: UIFont.circeRegular(with: 17), textColor: .mainTextColor())
    
    private lazy var hideOrderButton: UIButton = UIButton.getLittleRoundButton(backgroundColor: .detailsGrey(), text: "Скрыть", image: nil, font: UIFont.circeRegular(with: 17), textColor: .mainTextColor())
    
    private lazy var deleteOrderButton: UIButton =  UIButton.getLittleRoundButton(backgroundColor: .detailsGrey(), text: "Удалить", image: nil, font: UIFont.circeRegular(with: 17), textColor: .errorRed())
    
    private lazy var pageControl: UIPageControl = UIPageControl.getStandard(currentPageIndex: 0, numberOfPages: 0)
    
  // MARK: - Object lifecycle
    init(type: FeedOrderType) {
        self.type = type
        switch type {
        case .alienProfileOrder(model: let model):
            self.orderViewModel = model.order
        case .myProfileOrder(model: let model):
            self.orderViewModel = model
        case .mainFeedOrder(model: let model):
            self.orderViewModel = model.order
        }
//        orderViewModel = OrderViewModel(order: OrderViewModel.Order.init(title: "123", description: "123", counterOffer: "123", isFree: true, tags: [], photoAttachments: [URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!,URL(string: "https://developer.apple.com/documentation/uikit/uistackview/distribution")!]), user: OrderViewModel.User(userName: "123", userLastName: "123", userCity: "123", userPhoto: nil), orderId: 123, userId: 123)
        super.init(nibName: nil, bundle: nil)
        photosCollectionView = PhotosCarouselCollectionView(contentInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), pageControl: pageControl)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
  // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = FeedOrderInteractor()
        let presenter             = FeedOrderPresenter()
        let router                = FeedOrderRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
  }
  
  // MARK: Routing
  
  // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupRecognizers()
        setupNavigationController()
        setupDelegates()
    }
    
    
    override func loadView() {
        super.loadView()
        tagsCollectionView = TagsCollectionView(displayedTags: orderViewModel.tags, showOnly: true)
        setupElements()
        setupConstraints()

    }
    

    //MARK: - funcs
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displaySwapping:
            showAlert(title: "Успешно", message: "Можно обменяться")
        case .displayDeleting:
            showAlert(title: "Успешно", message: "Предложение можно удалить")
        case .displayNewHidingState(newState: let newState):
            showAlert(title: "Успешно", message: "Предложение теперь \(newState ? "cкрыто" : "раскрыто")")
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
    private func setupDelegates() {
        photosCollectionView.customDelegate = self
    }
    private func setupRecognizers() {
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        gesture.numberOfTapsRequired = 1
        topView.addGestureRecognizer(gesture)
        
        editOrderButton.addTarget(self, action: #selector(editOrderButtonTapped), for: .touchUpInside)
        hideOrderButton.addTarget(self, action: #selector(hideOrderButtonTapped), for: .touchUpInside)
        deleteOrderButton.addTarget(self, action: #selector(deleteOrderButtonTapped), for: .touchUpInside)
    }
    private func setupElements() {
        titleLabel.text = orderViewModel.title
        descriptionLabel.text = orderViewModel.description
        counterOfferLabel.text = orderViewModel.counterOffer
        photosCollectionView.set(photoAttachments: orderViewModel.photoAttachments.map{$0.absoluteString})
        if let isHidden = type.isHidden() {
            if isHidden {
                hideOrderButton.setTitle("Раскрыть", for: .normal)
            } else {
                hideOrderButton.setTitle("Скрыть", for: .normal)
            }
        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = type.getNavigationTitle()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.tintColor = .mainTextColor()
    }
    
    //MARK: - objc funcs
    @objc private func editOrderButtonTapped() {
        switch type {
        case .myProfileOrder(model: let model):
            router?.routeToEditOrder(model: model)
        default:
            break
        }
    }
    
    @objc private func hideOrderButtonTapped() {
        print(#function)
        if let isHidden = type.isHidden() {
            interactor?.makeRequest(request: .changeHidingState(currentState: isHidden))
        }

    }
    
    @objc private func deleteOrderButtonTapped() {
        interactor?.makeRequest(request: .tryToDelete(orderId: type.getOrderId()))
    }
    @objc private func swapButtonTapped() {
        print("Swap button tapped")
        #warning("мб имеет смысл сделать проверку, можно ли обратиться к order(возможно его уже приняли)")
        switch type {
        case .alienProfileOrder(model: let model):
            router?.routeToComments(commentsModel: CommentsOrderModel(orderId: model.orderId))
        case .mainFeedOrder(model: let model):
            router?.routeToComments(commentsModel: CommentsOrderModel(orderId: model.orderId))
        case .myProfileOrder(model: let model):
            break
        }
    }
    
    #warning("Зачем в параметрах userid")
    @objc private func topViewTapped(userId: Int) {
        print("topviewtapped")
        if let userId = type.getUserId() {
            router?.routToAlienProfile(userId: userId)
        }
    }
}

//MARK: - PhotosCollectionViewDelegate
extension FeedOrderViewController: PhotosCarouselDelegate {
    func photosCollectionViewSize() -> CGSize {
        let width = UIScreen.main.bounds.width - FeedOrderConstants.photosCollectionViewInset.left + FeedOrderConstants.photosCollectionViewInset.right
        let height = FeedOrderConstants.photosCollectionViewHeight
        print(width)
        return CGSize(width: photosCollectionView.frame.width * 0.91, height: photosCollectionView.frame.height)
    }
    
    func addPhotoButtonTapped() {
        print(#function)
        
    }
    
    
}

//MARK:- constraints
extension FeedOrderViewController {
    private func setupConstraints() {
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        

        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(wantSwapLabel)
        scrollView.addSubview(counterOfferLabel)
        
        if !type.isTopViewHidden() {
            scrollView.addSubview(topView)
            NSLayoutConstraint.activate([
                topView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.userImageHeight),
                topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                topView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: FeedOrderConstants.titleViewTopOffset)
            ])
            titleLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: FeedOrderConstants.titleLabelInsets.top).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: FeedOrderConstants.titleViewTopOffset).isActive = true
        }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.titleLabelInsets.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.titleLabelInsets.right)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedOrderConstants.descriptionLabelInsets.top),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.descriptionLabelInsets.left),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.descriptionLabelInsets.right)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedOrderConstants.descriptionLabelInsets.top),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.descriptionLabelInsets.left),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.descriptionLabelInsets.right)
        ])
        
        NSLayoutConstraint.activate([
            wantSwapLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: FeedOrderConstants.swapLabelInsets.top),
            wantSwapLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.swapLabelInsets.left),
            wantSwapLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.swapLabelInsets.right)
        ])
        
        NSLayoutConstraint.activate([
            counterOfferLabel.topAnchor.constraint(equalTo: wantSwapLabel.bottomAnchor, constant: FeedOrderConstants.swapLabelInsets.top),
            counterOfferLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.counterOfferLabelInsets.left),
            counterOfferLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.counterOfferLabelInsets.right)
        ])
        #warning("setup with real data")
//        let isFree = true
        let isFree = orderViewModel.isFree
        let interimView: UIView
        if isFree {
            scrollView.addSubview(freeSwapLabel)
            NSLayoutConstraint.activate([
                freeSwapLabel.topAnchor.constraint(equalTo: counterOfferLabel.bottomAnchor, constant: FeedOrderConstants.freeSwapLabelInsets.top),
                freeSwapLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.freeSwapLabelInsets.left),
                freeSwapLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.freeSwapLabelInsets.right)
            ])
            interimView = freeSwapLabel
        } else {
            interimView = counterOfferLabel
        }
        
        scrollView.addSubview(tagsCollectionView)
        scrollView.addSubview(photosCollectionView)
        scrollView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: interimView.bottomAnchor, constant: FeedOrderConstants.photosCollectionViewInset.top),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.photosCollectionViewHeight)
        ])
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(photosCollectionView.snp.bottom).inset(5)
        }
        
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 30),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.tagsCollectionViewHeight)
        ])
        
        if type.isSwapButtonHidden() {
            print("init stack view")
            let stackView = UIStackView(arrangedSubviews: [editOrderButton, hideOrderButton, deleteOrderButton], axis: .vertical, spacing: 8)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(stackView)
            
            stackView.snp.makeConstraints { (make) in
//                make.left.right.equalTo(titleLabel)
                make.left.equalTo(view.snp.left).offset(FeedOrderConstants.swapButtonInsets.left)
                make.right.equalTo(view.snp.right).offset(FeedOrderConstants.swapButtonInsets.right)
                make.top.equalTo(tagsCollectionView.snp.bottom).offset(FeedOrderConstants.swapButtonInsets.top)
                make.height.equalTo(FeedOrderConstants.stackViewButtonHeight * 3 + FeedOrderConstants.stackViewSpacing * 2)
                make.bottom.equalTo(scrollView.snp.bottom).offset(-UIScreen.main.bounds.height * 0.04)
            }
            
        } else {
            print("here")
            scrollView.addSubview(swapButton)
            NSLayoutConstraint.activate([
                swapButton.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: FeedOrderConstants.swapButtonInsets.top),
                swapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.swapButtonInsets.left),
                swapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.swapButtonInsets.right),
                swapButton.heightAnchor.constraint(equalToConstant: FeedOrderConstants.swapButtonHeight),
                swapButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.036)
            ])
        }

    }
}


// MARK: - SwiftUI
import SwiftUI

struct FeedOrderVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedOrderVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedOrderVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
