//
//  FeedCollectionLayout.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 25.01.2021.
//

import Foundation
import UIKit

struct FeedCollectionLayout {
    
    enum Section: Int, CaseIterable {
        case orders
    }
    private static var contentInset = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 15)
    private static var spacing = CGFloat(15)
    
    public static func feedCollectionViewHeight(cellsCount: Int) {
        let rowsCount = cellsCount / 2 + cellsCount % 2
        let spacesCount = rowsCount - 1
        let cellHeight = (screenSize.width - contentInset.leading - contentInset.trailing) * 0.6
        print(#function)
        print(cellHeight)
    }
    
    public static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        return sectionHeader
    }
    
    public static func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionFooter,
                                                                        alignment: .bottom)
        
        return sectionHeader
    }
    
    public static func createCompositionalLayout(supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]? = nil) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
        
            switch section {
            case .orders:
                return FeedCollectionLayout.createOrdersSection(supplementaryViews: supplementaryViews)
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    private static func createOrdersSection(supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]?) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(FeedCollectionLayout.spacing)
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = spacing
        section.contentInsets = FeedCollectionLayout.contentInset
        if let supplementaryViews = supplementaryViews {
            section.boundarySupplementaryItems = supplementaryViews
        }
        return section
    }
}
