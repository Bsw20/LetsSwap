//
//  MainFeedHeader.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 11.02.2021.
//

import Foundation
import UIKit
import SnapKit


class MainFeedHeader: UICollectionReusableView {
    static let reuseId = "MainFeedHeader"
    
    var tagsCollectionView: TagsCollectionView = {
       var collectionView = TagsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//
        addSubview(tagsCollectionView)
//
        tagsCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(17)
            make.height.height.equalTo(FeedConstants.tagsCollectionViewHeight)
            make.bottom.equalToSuperview().priority(990)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTagsDelegate(delegate: TagCollectionViewDelegate) {
        tagsCollectionView.tagDelegate = delegate
    }
}

