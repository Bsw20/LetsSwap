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
    func favouriteButtonTapped(newState: Bool)
}

class FeedCollectionView: UICollectionView {
    
    weak var feedDelegate: FeedCollectionViewDelegate?
    
    private var feedViewModel = FeedViewModel.init(cells: [])
    private var localDataSource: UICollectionViewDiffableDataSource<FeedCollectionLayout.Section, FeedViewModel.Cell>!
 
    
    init() {

        super.init(frame: .zero, collectionViewLayout: FeedCollectionLayout.createCompositionalLayout())
        delegate = self
        createDataSource()
        backgroundColor = .mainBackground()
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        allowsMultipleSelection = false
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
}

extension FeedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = feedViewModel.cells[indexPath.item]
        print(indexPath)
        feedDelegate?.cellDidSelect(orderId: cellModel.orderId)
        
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
    }
}

extension FeedCollectionView: FeedCellDelegate {
    #warning("Обсудить put запрос с бэком")
    func favouriteButtonDidTapped(indexPath: IndexPath) {
        print("favourite button tapped + \(indexPath)")
    }
}
