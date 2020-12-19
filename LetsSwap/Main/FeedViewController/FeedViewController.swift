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
    private var tagsCollectionView: TagsCollectionView = {
       var collectionView = TagsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var feedCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, FeedViewModel.Cell>!
    private var titleView = TitleView()
    private var feedViewModel = FeedViewModel.init(cells: [FeedViewModel.Cell.init(orderId: 12, title: "123", description: "123", counterOffer: "123", photo: nil, isFavourite: true, isFree: true),
                                                           FeedViewModel.Cell.init(orderId: 13, title: "123", description: "156", counterOffer: "134", photo: nil, isFavourite: true, isFree: true)])

    
    enum Section: Int, CaseIterable {
        case orders
    }
    
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
        tagsCollectionView.tagDelegate = self
        
        setupFeedCollectionView()
        createDataSourse()
        setupSearchBar()
        setupConstraints()
        self.reloadData(with: nil)

    }
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            print("reload data")
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayEmptyFeed: //war
            #warning("TODO: ждать дизайнеров")
            showAlert(title: "Ошибка", message: "")
        }
    }
    
    private func setupFeedCollectionView() {
        feedCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedCollectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        feedCollectionView.backgroundColor = .mainBackground()
        
//        feedCollectionView.delegate = self
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
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
    
    private func reloadData(with searchText: String?) {
//        let filtred = users.filter { (user) -> Bool in
//            user.contains(filter: searchText)
//        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedViewModel.Cell>()
        
        snapshot.appendSections([.orders])
        snapshot.appendItems(feedViewModel.cells, toSection: .orders)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

}
//MARK: - FeedCollecitonView DataSource
extension FeedViewController {
    private func createDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, FeedViewModel.Cell> (collectionView: feedCollectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            print("Created")
            
            switch section {
            
            case .orders:
                print("generate cell")
                let cell = self.feedCollectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath)
                return cell
            }
        })
    }
}

//MARK: - FeedCollecitonView layout
extension FeedViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
        
            switch section {
            case .orders:
                return self.createOrdersSection()
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    private func createOrdersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 15)

        return section
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
            feedCollectionView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 40),
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

