//
//  FeedViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedDisplayLogic: class {
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
    //variables
    
    private var feedCollectionView: FeedCollectionView

    private var titleView = TitleView()
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?
    private var selectedTags: Set<FeedTag> {
        return feedCollectionView.getSelectedTags()
    }

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feedCollectionView = FeedCollectionView(type: .withHeader)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init doesn't implemented")
    }
    
  
  // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = FeedInteractor()
        let presenter             = FeedPresenter()
        let router                = FeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
  
  // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        feedCollectionView.customDelegate = self
        titleView.customDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardFromTopView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        setupSearchBar()
        setupConstraints()
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                           text: titleView.getTextFieldText())))
        view.layoutIfNeeded()


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags, text: titleView.getTextFieldText())))
        #warning("Заглушка для favorites. Часто не работает через updateData")
        feedCollectionView.reloadData()
        navigationController?.hidesBarsOnSwipe = true
        print("VIEW WILL DISAPPEAR")
      }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
      }
    
    
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            feedCollectionView.updateData(feedViewModel: feedViewModel)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayEmptyFeed:
            #warning("TODO: ждать дизайнеров    ")
            showAlert(title: "Ошибка", message: "")
        }
        view.isUserInteractionEnabled = true
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .mainBackground()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationItem.prompt = nil
        self.navigationItem.titleView = titleView
    }
    private func applyFilterToFeed() {
        let inputText = titleView.getTextFieldText()
        let tags = selectedTags
        interactor?.makeRequest(request: .getFilteredFeed(model:
                                                            FiltredFeedModel(
                                                                selectedTags: tags,
                                                                text: inputText
                                                            )))
    }
    
    
    @objc private func hideKeyboardFromTopView() {
        titleView.endEditing(true)
    }
    
}

//MARK: - FeedViewControllerDelegate
extension FeedViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
        view.isUserInteractionEnabled = false
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    
    func showAlert(title: String, message: String) {
        UIViewController.showAlert(title: title, message: message)
    }
    
    func selectedTagsChanged() {
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                           text: titleView.getTextFieldText())))
    }
    func moreTagsButtonTapped() {
//        router?.routeToTagsController(currentTags: selectedTags)
        UIViewController.showAlert(title: "Уведомление!", message: "Данный функционал будет реализован позже")
    }
    
    func refresh() {
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                           text: titleView.getTextFieldText())))
    }
    
    
}

//MARK: - constraints
extension FeedViewController {
    private func setupConstraints() {
        view.addSubview(feedCollectionView)

        feedCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension FeedViewController: TitleViewDelegate {
    func textDidChange(newText: String) {
        applyFilterToFeed()
    }
    
    func cityButtonTapped() {
        router?.routeToCitiesController()
    }
    
    
}

// MARK: - SwiftUI
import SwiftUI

struct FeedVCProvider: PreviewProvider {
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

