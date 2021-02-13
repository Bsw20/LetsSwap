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
    private var selectedTags = Set<FeedTag>()
    
    private var feedCollectionView: FeedCollectionView

    private var titleView = TitleView()
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feedCollectionView = FeedCollectionView(type: .withHeader)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        feedCollectionView.setTagsDelegate(delegate: self)
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
        titleView.delegate = self
        
        setupSearchBar()
        setupConstraints()
        interactor?.makeRequest(request: .getFeed)

    }
    
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            print("reload data")
            print(feedViewModel.cells.count)
            feedCollectionView.updateData(feedViewModel: feedViewModel)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayEmptyFeed:
            #warning("TODO: ждать дизайнеров")
            showAlert(title: "Ошибка", message: "")
        }
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
}

//MARK: - FeedViewControllerDelegate
extension FeedViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    
    func showAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
}

//MARK: - SearchBar
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reloadData(with: searchText)
        print(searchText)
    }
}

//MARK: - TagCollectionViewDelegate
extension FeedViewController: TagCollectionViewDelegate {
    func tagDidSelect(tag: FeedTag) {
        print("VC")
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        print(selectedTags)
        interactor?.makeRequest(request: .getFilteredFeed(tags: selectedTags))
    }
    
    func moreTagsCellDidSelect() {
        print("VC")
        print("more button selected")
        router?.routeToTagsController(currentTags: selectedTags)
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

