//
//  FeedCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.12.2020.
//

import Foundation
import UIKit

protocol FeedCollectionViewDelegate: AnyObject {
    func cellDidSelect(orderId: Int)
    func showAlert(title: String, message: String)
//    func favouriteButtonTapped(newState: Bool)
//    func getSelectedTags(tags: [FeedTag])
//    func setSelectedTags(tags: [FeedTag])
}

class FeedCollectionView: UICollectionView {
    //MARK: - variables
    enum ViewType{
        case withHeader
        case withoutHeader
    }
    private var favoriteManager = FavoriteOrderManager.shared
    
    weak var customDelegate: FeedCollectionViewDelegate?
    private weak var tagsDelegate: TagCollectionViewDelegate? {
        didSet {
            tagsCollectionView?.tagDelegate = tagsDelegate
        }
    }
    private var feedViewModel = FeedViewModel.init(cells: [])
    private var localDataSource: UICollectionViewDiffableDataSource<FeedCollectionLayout.Section, FeedViewModel.Cell>!
    private var tagsCollectionView: TagsCollectionView? {
        didSet {
            tagsCollectionView?.tagDelegate = tagsDelegate
        }
    }
 
    
    init(type:ViewType) {
        var supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]? = nil
        switch type {
        
        case .withoutHeader:
            supplementaryViews = nil
        case .withHeader:
            supplementaryViews = [FeedCollectionLayout.createSectionHeader()]
        }
        let layout = FeedCollectionLayout.createCompositionalLayout(supplementaryViews: supplementaryViews)
        super.init(frame: .zero, collectionViewLayout:layout )
        register(MainFeedHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainFeedHeader.reuseId)
        delegate = self
        createDataSource()
        backgroundColor = .mainBackground()
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        allowsMultipleSelection = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func updateData(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        var snapshot = NSDiffableDataSourceSnapshot<FeedCollectionLayout.Section, FeedViewModel.Cell>()
        
        snapshot.appendSections([.orders])
        snapshot.appendItems(self.feedViewModel.cells, toSection: .orders)

        localDataSource?.apply(snapshot, animatingDifferences: true)

        reloadData()
    }
    
    func setTagsDelegate(delegate: TagCollectionViewDelegate) {
        self.tagsDelegate = delegate
    }
    
}

extension FeedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = feedViewModel.cells[indexPath.item]
        print(indexPath)
        customDelegate?.cellDidSelect(orderId: cellModel.orderId)
    }
}

//MARK: - FeedCollecitonView DataSource
extension FeedCollectionView {
    private func createDataSource() {
        localDataSource = UICollectionViewDiffableDataSource<FeedCollectionLayout.Section, FeedViewModel.Cell> (collectionView: self, cellProvider: {[weak self] (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = FeedCollectionLayout.Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
    
            switch section {
            
            case .orders:
                let cell = self?.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
                let cellModel = self?.feedViewModel.cells[indexPath.item]
                #warning("Если cell model не корректный(мб allert)")
                cell.set(cellType: FeedCell.FeedCellType.mainFeedCell(cellViewModel: cellModel!), indexPath: indexPath)
                cell.delegate = self
                return cell
            }
        })
        localDataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainFeedHeader.reuseId, for: indexPath) as? MainFeedHeader else { fatalError("Can not create new section header") }
            
//            sectionHeader.configure(text: section.description(usersCount: items.count),
//                                    font: .systemFont(ofSize: 36, weight: .light ),
//                                    textColor: .label)
            self.tagsCollectionView = sectionHeader.tagsCollectionView
            
            print("supplementary")
            return sectionHeader
        }
    }
}

extension FeedCollectionView: FeedCellDelegate {
    #warning("Обсудить put запрос с бэком")
    func favouriteButtonDidTapped(indexPath: IndexPath) {
        print("favourite button tapped + \(indexPath)")
        let currentOrder = feedViewModel.cells[indexPath.item]
        print(currentOrder.isFavourite)
        favoriteManager.changeState(orderID: currentOrder.orderId, isFavorite: currentOrder.isFavourite) {[weak self] (result) in
            switch result {
            
            case .success(let newState):
                self?.feedViewModel.cells[indexPath.item].isFavourite = newState
//                self?.reloadItems(at: [indexPath])
                print("RELOADING")
                self?.reloadData()
                print(self?.feedViewModel.cells[indexPath.item].isFavourite)
            case .failure(let error):
                self?.customDelegate?.showAlert(title: "Ошибка!", message: "Localized description")
            }
        }

        
    }
}
