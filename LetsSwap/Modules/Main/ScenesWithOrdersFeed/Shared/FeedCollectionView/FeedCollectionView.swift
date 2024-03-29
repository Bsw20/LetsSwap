//
//  FeedCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.12.2020.
//

import Foundation
import UIKit
import SwiftyBeaver

@objc protocol FeedCollectionViewDelegate: AnyObject {
    func cellDidSelect(orderId: Int)
    func showAlert(title: String, message: String)
    @objc optional func moreTagsButtonTapped()
    @objc optional func selectedTagsChanged()
    @objc optional func favouriteButtonTapped(newState: Bool)
    @objc optional func refresh()
}

class FeedCollectionView: UICollectionView {
    //MARK: - Controls

    //MARK: - variables
    enum ViewType{
        case withHeader
        case withoutHeader
    }
    private var favoriteManager = FavoriteOrderManager.shared
    
    weak var customDelegate: FeedCollectionViewDelegate?
    
    private var feedViewModel = FeedViewModel.init(cells: [])
    private var localDataSource: UICollectionViewDiffableDataSource<FeedCollectionLayout.Section, FeedViewModel.Cell>!
    private var selectedTags: Set<FeedTag> = []
 
    
    init(type:ViewType) {
        var supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]? = nil
        switch type {
        
        case .withoutHeader:
            supplementaryViews = nil
        case .withHeader:
            supplementaryViews = [FeedCollectionLayout.createSectionHeader()]
        }
        let layout = FeedCollectionLayout.createCompositionalLayout(supplementaryViews: supplementaryViews)
        super.init(frame: .zero, collectionViewLayout:layout)
        register(MainFeedHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainFeedHeader.reuseId)
        delegate = self
        createDataSource()
        backgroundColor = .mainBackground()
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        allowsMultipleSelection = false
        translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl =  {
            let refreshControl = UIRefreshControl()

            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            return refreshControl
        }()
    }
    
    @objc private func refresh() {
        print(#function)
        customDelegate?.refresh?()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func updateData(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        var snapshot = NSDiffableDataSourceSnapshot<FeedCollectionLayout.Section, FeedViewModel.Cell>()
        
        snapshot.appendSections([.orders])
        snapshot.appendItems(self.feedViewModel.cells, toSection: .orders)
        
        onMainThread {
            self.localDataSource?.apply(snapshot, animatingDifferences: true, completion: {
                 self.localDataSource?.apply(snapshot, animatingDifferences: false)
            })
        }
        refreshControl?.endRefreshing()
    }
    
    public func setSelectedTags(tags: Set<FeedTag>) {
        selectedTags = tags
    }
    
}

extension FeedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = feedViewModel.cells[indexPath.item]
        customDelegate?.cellDidSelect(orderId: cellModel.orderId)
    }
}

//MARK: - FeedCollecitonView DataSource
extension FeedCollectionView {
    private func createDataSource() {
        localDataSource = UICollectionViewDiffableDataSource<FeedCollectionLayout.Section, FeedViewModel.Cell> (collectionView: self, cellProvider: {[weak self] (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let self = self else { return nil}
            guard let section = FeedCollectionLayout.Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
    
            switch section {
            
            case .orders:
                let cell = self.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
                guard indexPath.item < self.feedViewModel.cells.count else { return cell}
                let cellModel = self.feedViewModel.cells[indexPath.item]
                #warning("Если cell model не корректный(мб allert)")
                cell.set(cellType: FeedCell.FeedCellType.mainFeedCell(cellViewModel: cellModel))
                cell.delegate = self
                return cell
            }
        })
        localDataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainFeedHeader.reuseId, for: indexPath) as? MainFeedHeader else { fatalError("Can not create new section header") }
            
            sectionHeader.configure(selectedTags: self.selectedTags)
            sectionHeader.setTagsDelegate(delegate: self)
            return sectionHeader
        }
    }
    
    func getSelectedTags() -> Set<FeedTag> {
        return selectedTags
    }
}

//MARK: - Comment

extension FeedCollectionView: TagCollectionViewDelegate {
    
    func tagDidSelect(selectedTags: Set<FeedTag>) {
        self.selectedTags = selectedTags
        customDelegate?.selectedTagsChanged?()
    }
    
    func moreTagsCellDidSelect() {
        customDelegate?.moreTagsButtonTapped?()
    }
}

//MARK: - FeedCellDelegate
extension FeedCollectionView: FeedCellDelegate {
    #warning("Обсудить put запрос с бэком")
    func favouriteButtonDidTapped(cell: FeedCell) {
        guard let item = indexPath(for: cell)?.item else {
            SwiftyBeaver.error("Cell didn't found")
            fatalError("Cell didn't found")
        }
        let currentOrder = feedViewModel.cells[item]
        favoriteManager.changeState(orderID: currentOrder.orderId, isFavorite: currentOrder.isFavourite) {[weak self] (result) in
            switch result {
            
            case .success(let newState):
                SwiftyBeaver.info("New value \(newState)")
                self?.feedViewModel.cells[item].isFavourite = newState
                self?.reloadData()
                self?.customDelegate?.favouriteButtonTapped?(newState: newState)
            case .failure(let error):
                self?.customDelegate?.showAlert(title: "Ошибка!", message: "Localized description")
            }
        }

        
    }
}
