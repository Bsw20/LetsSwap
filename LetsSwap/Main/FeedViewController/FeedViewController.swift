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
    var collectionViewe: UICollectionView!
    var titleView = TitleView()
    
    
    
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
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupSearchBar()
    }
  
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {

    }
    
    private func setupSearchBar() {
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.shadowImage = UIImage()
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
}

//MARK: - SearchBar
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reloadData(with: searchText)
        print(searchText)
    }
}
