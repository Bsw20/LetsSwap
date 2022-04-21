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
    func addPhotoButtonTapped(view: PhotosCollectionView )
}

enum PhotosCollectionViewElementsType {
    case video
    case photo
}

struct PhotosCollectionViewModel {
    let type: PhotosCollectionViewElementsType
    let url : String
}

class PhotosCollectionView: UICollectionView {

    private var attachments: [PhotosCollectionViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var photosDelegate: PhotosCollectionViewDelegate?
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(MediaCollectionCell.self, forCellWithReuseIdentifier: MediaCollectionCell.reuseId)
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
    public func set(attachments:[PhotosCollectionViewModel]) {
        self.attachments = attachments
        reloadData()
    }
    public func add(attachment: PhotosCollectionViewModel) {
        attachments.append(attachment)
    }
    private func delete(attachment: PhotosCollectionViewModel) {
        attachments = attachments.filter {$0.url != attachment.url}

    }
    
    private func remove(at: Int) {
        attachments.remove(at: at)
        reloadData()
    }
    
    public func getPhotoAttachments() -> [String] {
        return attachments.filter{$0.type == .photo}.map {$0.url}
    }
    
    public func getVideoAttachments() -> [String] {
        return attachments.filter{$0.type == .video}.map {$0.url}
    }
}

extension PhotosCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlusButtonCell.reuseId, for: indexPath) as! PlusButtonCell
            cell.customDelegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.reuseId, for: indexPath) as! MediaCollectionCell
//        cell.configure(imageUrl: photoAttachments[indexPath.item - 1])
        let attachment = attachments[indexPath.item - 1]
        cell.configure(imageUrl: attachment.url, mediaType: attachment.type == .photo ? .photo : .video)
        cell.delegate = self
        cell.isInEditingMode = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photosDelegate?.photosCollectionViewSize() ?? CGSize(width: frame.height, height: frame.height)
    }
}

//MARK: - PlusButtonCellDelegate
extension PhotosCollectionView: PlusButtonCellDelegate {
    func addButtonTapped() {
        photosDelegate?.addPhotoButtonTapped(view: self)
    }
}

//MARK: - PhotoCelDelegate
extension PhotosCollectionView: PhotoCellDelegate {
    func deleteButtonTapped(cell: MediaCollectionCell) {
        let ip = indexPath(for: cell)
        if let ip = ip {
            remove(at: ip.item - 1)
        }
    }
}
