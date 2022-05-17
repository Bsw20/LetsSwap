//
//  PhotosCarouselCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 04.02.2021.
//

import Foundation
import UIKit
import SnapKit


protocol PhotosCarouselDelegate: NSObjectProtocol {
    func photosCollectionViewSize() -> CGSize
    func didTap(collectionView: PhotosCarouselCollectionView, model: PhotosCarouselViewModel)
}

struct PhotosCarouselViewModel {
    let type: PhotosCarouselEntityType
    let url: String?
}

enum PhotosCarouselEntityType {
    case photo
    case video
}

class PhotosCarouselCollectionView: UICollectionView {
    //MARK: - Contols
    private var pageControl: UIPageControl
    //MARK: - Variables
    private var attachments: [PhotosCarouselViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var customDelegate: PhotosCarouselDelegate?
    
    //MARK: - Object lifecycle
    public init(contentInset: UIEdgeInsets, pageControl: UIPageControl) {
        self.pageControl = pageControl
        pageControl.currentPage = 0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(MediaCollectionCell.self, forCellWithReuseIdentifier: MediaCollectionCell.reuseId)
        dataSource = self
        delegate = self
        backgroundColor = .mainBackground()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        self.contentInset = contentInset
        self.translatesAutoresizingMaskIntoConstraints = false
        allowsMultipleSelection = false

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(attachments: [PhotosCarouselViewModel]) {
        print(attachments.map{$0.url})
        pageControl.numberOfPages = attachments.count
        pageControl.currentPage = 0
        self.attachments = attachments
        print(#function)
    }
}

//MARK: - Collection delegates&dataSource
extension PhotosCarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count == 0 ? 1 : attachments.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard attachments.count != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.reuseId, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.reuseId, for: indexPath) as! MediaCollectionCell
        let attachment = attachments[indexPath.item]
        cell.configure(imageUrl: attachment.url, mediaType: attachment.type == .photo ? .photo : .video)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return customDelegate?.photosCollectionViewSize() ?? collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.didTap(collectionView: self, model: attachments[indexPath.item])
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width * 0.91 - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
}

