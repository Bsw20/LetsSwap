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
}

class PhotosCarouselCollectionView: UICollectionView {
    //MARK: - Contols
    private var pageControl: UIPageControl
    //MARK: - Variables
    private var photoAttachments: [StringURL] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var customDelegate: PhotosCarouselDelegate?
    
    //MARK: - Object lifecycle
    public init(contentInset: UIEdgeInsets, pageControl: UIPageControl) {
        self.pageControl = pageControl
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        dataSource = self
        delegate = self
        backgroundColor = .mainBackground()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        self.contentInset = contentInset
        allowsSelection = false
        self.translatesAutoresizingMaskIntoConstraints = false
        isPagingEnabled = true

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(photoAttachments: [StringURL]) {
        pageControl.numberOfPages = photoAttachments.count
        pageControl.currentPage = 0
        self.photoAttachments = photoAttachments
        print(#function)
    }
}

//MARK: - Collection delegates&dataSource
extension PhotosCarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAttachments.count == 0 ? 1 : photoAttachments.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard photoAttachments.count != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
        cell.set(imageUrl: photoAttachments[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("here")
        return customDelegate?.photosCollectionViewSize() ?? collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width * 0.91 - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == self {
////            CGPoint currentCellOffset = self.collectionView.contentOffset;
////              currentCellOffset.x += self.collectionView.frame.size.width / 2;
////              NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentCellOffset];
////              [self.collectionView scrollToItemAtIndexPath:indexPath
////                                          atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
////                                                  animated:YES];
//            var currentCellOffset = contentOffset
//            currentCellOffset.x += frame.size.width / 4
//            var indexPath = indexPathForItem(at: currentCellOffset)
//            print(indexPath)
//            if let indexPath = indexPath {
//                scrollToItem(at: IndexPath(item: 3, section: 0), at: .left, animated: true)
//            }
//
//        }
//    }
}

