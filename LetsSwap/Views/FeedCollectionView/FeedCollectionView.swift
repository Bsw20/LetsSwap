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
    private var localDataSource: UICollectionViewDiffableDataSource<Section, FeedViewModel.Cell>!
    private enum Section: Int, CaseIterable {
        case orders
    }
    
    init() {

        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) //TODO: убрать костыль
        delegate = self
        self.collectionViewLayout = createCompositionalLayout()
        createDataSource()
        backgroundColor = .mainBackground()
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func updateData(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedViewModel.Cell>()
        
        snapshot.appendSections([.orders])
        snapshot.appendItems(self.feedViewModel.cells, toSection: .orders)

        localDataSource?.apply(snapshot, animatingDifferences: true)

        reloadData()
    }
}

extension FeedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = feedViewModel.cells[indexPath.item]
        feedDelegate?.cellDidSelect(orderId: cellModel.orderId)
        
    }
}

//MARK: - FeedCollecitonView DataSource
extension FeedCollectionView {
    private func createDataSource() {
        localDataSource = UICollectionViewDiffableDataSource<Section, FeedViewModel.Cell> (collectionView: self, cellProvider: {[weak self] (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
    
            switch section {
            
            case .orders:
                let cell = self?.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
                let cellModel = self?.feedViewModel.cells[indexPath.item]
                #warning("Если cell model не корректный(мб allert)")
                cell.set(cellModel: cellModel!, indexPath: indexPath)
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

//MARK: - FeedCollecitonView layout
extension FeedCollectionView {
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
