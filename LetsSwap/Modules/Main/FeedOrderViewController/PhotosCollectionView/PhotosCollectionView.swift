//
//  PhotosCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit

protocol PhotosCollectionViewDelegate: AnyObject {
    func photosCollectionViewSize() -> CGSize
}

class PhotosCollectionView: UICollectionView {
    private var photoAttachments: [URL]
    
    weak var photosDelegate: PhotosCollectionViewDelegate!
    init(photoAttachments: [URL]) {
        self.photoAttachments = photoAttachments
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        dataSource = self
        delegate = self
        backgroundColor = .mainBackground()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        allowsSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotosCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAttachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
        cell.set(imageURL: photoAttachments[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photosDelegate.photosCollectionViewSize()
    }
}
