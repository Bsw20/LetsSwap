//
//  TagsViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit

class TagsViewController: UIViewController {
//    weak var k
    private var displayedTags = FeedTag.allCases
    
    private var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupCollectionView()
        setupConstraints()
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout )
        collectionView.contentInset = FeedConstants.tagsViewControllerTagsInset
        collectionView.backgroundColor = .mainBackground()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
}


//MARK: - CollectionView delegate&datasource
extension TagsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //tags collection view
        return displayedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //tags collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
        let stringTag = displayedTags[indexPath.item].rawValue
        cell.set(tagString: stringTag)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: - CollectionView flow layout
extension TagsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentStringTag = displayedTags[indexPath.item].rawValue
        let stringSize = currentStringTag.sizeOfString(usingFont: UIFont.circeRegular(with: 15))
        let cellWidth = stringSize.width + FeedConstants.tagCellPadding * 2
        let cellHeight = FeedConstants.tagsCollectionViewHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - SwiftUI
import SwiftUI

struct TagsVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tagsVC = TagsViewController()

        func makeUIViewController(context: Context) -> some TagsViewController {
            return tagsVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
