//
//  NotificationCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//

import Foundation
import UIKit

class NotificationCollectionView: UICollectionView {
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumInteritemSpacing = 60
//        flowLayout.minimumLineSpacing = 60
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        backgroundColor = .mainBackground()
//        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        dataSource = self
        delegate = self
        register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Delegate&DataSource
extension NotificationCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.reuseId, for: indexPath) as! NotificationCell
        cell.set(notificationType: .matched)
        return cell
    }
}

//MARK: - CollectionView flow layout
extension NotificationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - NotificationSceneConstants.leadingTrailingOffset * 2
        let height:CGFloat = 210
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: NotificationSceneConstants.topOffset,
                            left: NotificationSceneConstants.leadingTrailingOffset,
                            bottom: 0,
                            right: NotificationSceneConstants.leadingTrailingOffset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return NotificationSceneConstants.interitemSpacing
    }
}

// MARK: - SwiftUI
import SwiftUI

struct NotificationCollectionProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notifVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return notifVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

