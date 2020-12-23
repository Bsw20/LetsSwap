//
//  FeedViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedDisplayLogic: class {
  func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
    //variables
    private var selectedTags = Set<FeedTag>()
    
    //controls
    private var tagsCollectionView: TagsCollectionView = {
       var collectionView = TagsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var feedCollectionView: FeedCollectionView = {
       var collectionView = FeedCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var titleView = TitleView()
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        tagsCollectionView.tagDelegate = self
        feedCollectionView.feedDelegate = self
        
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
    
    func favouriteButtonTapped(newState: Bool) {
        print("favouriteButtonTapped")
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
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        print(selectedTags)
        interactor?.makeRequest(request: .getFilteredFeed(tags: selectedTags))
    }
    
    func moreTagsCellDidSelect() {
        print("more button selected")
        router?.routeToTagsController(currentTags: selectedTags)
    }
}


//MARK: - constraints
extension FeedViewController {
    private func setupConstraints() {
        view.addSubview(tagsCollectionView)
        view.addSubview(feedCollectionView)

        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: FeedConstants.tagsCollectionViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            feedCollectionView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 20),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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

