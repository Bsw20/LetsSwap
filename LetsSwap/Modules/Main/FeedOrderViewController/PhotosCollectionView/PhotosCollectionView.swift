//
//  PhotosCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit

protocol PhotosCollectionViewDelegate: NSObjectProtocol {
    func photosCollectionViewSize() -> CGSize
    func addPhotoButtonTapped()
}

class PhotosCollectionView: UICollectionView {
    private var photoAttachments: [String?]
    
    weak var photosDelegate: PhotosCollectionViewDelegate?
    
    init(photoAttachments: [String?]) {
        self.photoAttachments = photoAttachments
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        register(PlusButtonCell.self, forCellWithReuseIdentifier: PlusButtonCell.reuseId)
        dataSource = self
        delegate = self
        backgroundColor = .mainBackground()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        allowsSelection = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotosCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAttachments.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlusButtonCell.reuseId, for: indexPath) as! PlusButtonCell
            cell.customDelegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
//        cell.set(imageURL: photoAttachments[indexPath.item])
        cell.set(imageUrl: photoAttachments[indexPath.item - 1])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photosDelegate?.photosCollectionViewSize() ?? CGSize(width: frame.height, height: frame.height)
    }
}

//MARK: - PlusButtonCellDelegate
extension PhotosCollectionView: PlusButtonCellDelegate {
    func addButtonTapped() {
        photosDelegate?.addPhotoButtonTapped()
    }
    
    
}
