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
    public static func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
        
            switch section {
            case .orders:
                return FeedCollectionLayout.createOrdersSection()
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    private static func createOrdersSection() -> NSCollectionLayoutSection {
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
