//
//  FeedOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedOrderDisplayLogic: class {
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData)
}

protocol OrderRepresentableModel {

    var title: String { get }
    var description: String { get }
    var counterOffer: String { get }
    var isFree: Bool { get }
    var tags: [FeedTag] { get }
    var photoAttachments: [URL]{ get }
}
protocol UserRepresentableModel {
    var userName: String { get }
    var userLastName: String { get }
    var userCity: String { get}
    var userPhoto: URL? { get }
    
}

class FeedOrderViewController: UIViewController, FeedOrderDisplayLogic {
    //variables
    private var orderViewModel: OrderViewModel!
    //controls
    private var photosCollectionView: PhotosCollectionView = {
        var collectionView = PhotosCollectionView(photoAttachments: [URL(string: "https://docs.google.com/spreadsheets/d/1AhhHjDJGgdtP8hAuqXCmajBaPVaxxr11Pgm84Dox7LM/edit#gid=835090974")!,
            URL(string: "https://docs.google.com/spreadsheets/d/1AhhHjDJGgdtP8hAuqXCmajBaPVaxxr11Pgm84Dox7LM/edit#gid=835090974")!])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
}()
    private var tagsCollectionView: TagsCollectionView = {
        var collectionView = TagsCollectionView(displayedTags: [.advertAgain, .building, .fashion, .IT], showOnly: true)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
//    private lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .mainBackground()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = true
//        return view
//    }()
    
    private var topView: OrderTitleView = {
       let view = OrderTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var swapButton: UIButton = {
        let button = LittleRoundButton.newButton(backgroundColor: .mainYellow(), text: "Махнуться", image: nil, font: .circeRegular(with: 22), textColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    var interactor: FeedOrderBusinessLogic?
    var router: (NSObjectProtocol & FeedOrderRoutingLogic)?

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
//    init(orderViewModel: OrderViewModel) {
//        self.orderViewModel = orderViewModel
//    setup()
//    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
  

  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()

        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        print(swapButton.frame)
        
    }
    override func loadView() {
        super.loadView()
        setupConstraints()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: swapButton.frame.maxY + 40)
        

    }
  
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData) {

    }
    @objc private func swapButtonTapped() {
        print("Swap button tapped")
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
        
        
        scrollView.addSubview(topView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(wantSwapLabel)
        scrollView.addSubview(counterOfferLabel)
        
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.userImageHeight),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: FeedOrderConstants.titleViewTopOffset)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: FeedOrderConstants.titleLabelInsets.top),
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
        let isFree = true
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
        
        scrollView.addSubview(swapButton)
        scrollView.addSubview(tagsCollectionView)
        scrollView.addSubview(photosCollectionView)
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: interimView.bottomAnchor, constant: FeedOrderConstants.photosCollectionViewInset.top),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.photosCollectionViewInset.left),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.photosCollectionViewInset.right),
            photosCollectionView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.photosCollectionViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 30),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.tagsCollectionViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            swapButton.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: FeedOrderConstants.swapButtonInsets.top),
            swapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FeedOrderConstants.swapButtonInsets.left),
            swapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: FeedOrderConstants.swapButtonInsets.right),
            swapButton.heightAnchor.constraint(equalToConstant: FeedOrderConstants.swapButtonHeight),
            swapButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
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

