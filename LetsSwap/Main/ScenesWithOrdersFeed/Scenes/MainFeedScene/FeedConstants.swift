//
//  FeedConstants.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit

struct FeedConstants {
    static let tagCellPadding: CGFloat = 30
    static let tagsCollectionViewHeight: CGFloat = 43
    static let tagsCollectionViewInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    static let tagsViewControllerTagsInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    
    static let titleFeedCellInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 5)
    static let descriptionFeedCellInset = UIEdgeInsets(top: 777, left: 10, bottom: 10, right: 5)
    
    static let favouriteButtonSize = CGSize(width: 25, height: 25)
    static let favoutiteButtonInset = UIEdgeInsets(top: 777, left: 777, bottom: 7, right: 7)
}

import SwiftUI

struct FeedConstantsProvider: PreviewProvider {
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
