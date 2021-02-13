//
//  TagsCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit

protocol TagCollectionViewDelegate: AnyObject {
    func tagDidSelect(selectedTags: Set<FeedTag>)
    func moreTagsCellDidSelect()
}


class TagsCollectionView: UICollectionView {
    private static var defaultDisplayedTags = [FeedTag.IT, FeedTag.householdServices,FeedTag.art, FeedTag.beautyHealth,FeedTag.fashion, FeedTag.education, FeedTag.celebrations, FeedTag.cleaning, FeedTag.design]
    
    weak open var tagDelegate: TagCollectionViewDelegate?
    private var selectedTags = Set<FeedTag>()
    private var moreTagsString = "Еще"
    private var displayedTags: [FeedTag]
    private var showOnly: Bool
    init(displayedTags: [FeedTag] = defaultDisplayedTags, showOnly: Bool = false) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.displayedTags = displayedTags
        self.showOnly = showOnly
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
        if showOnly {
            allowsSelection = false
        }
        dataSource = self
        delegate = self
        backgroundColor = .mainBackground()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInset = FeedConstants.tagsCollectionViewInset
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    private func getDisplayedTagString(index: Int) -> String {
        if index == displayedTags.count {
            return moreTagsString
        } else if index >= 0 && index < displayedTags.count {
            return displayedTags[index].rawValue
        }
        fatalError("Индекс должен быть в пределах 0 до displayedTags.count")
    }
    
    
    func setSelectedTags(selectedTags: Set<FeedTag>) {
        self.selectedTags = selectedTags
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - CollectionView delegate&datasource
extension TagsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //tags collection view
        if showOnly {
            return displayedTags.count
        }
        return displayedTags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //tags collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
        let stringTag = getDisplayedTagString(index: indexPath.item)
        
        if showOnly || stringTag == moreTagsString {
            cell.set(tagString: stringTag)
            return cell
        }
        
        if selectedTags.contains(displayedTags[indexPath.item]) {
            cell.selectedCellSet(tagString: stringTag)
        } else {
            cell.set(tagString: stringTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == displayedTags.count {
            tagDelegate?.moreTagsCellDidSelect()
        } else if indexPath.item  >= 0 && indexPath.item  < displayedTags.count {
            let selectedTag = displayedTags[indexPath.item]
            if selectedTags.contains(selectedTag){
                selectedTags.remove(selectedTag)
            } else {
                selectedTags.insert(selectedTag)
            }
//            reloadData()
            reloadItems(at: [indexPath])
            tagDelegate?.tagDidSelect(selectedTags: selectedTags)
        }
    }
    
    
}

//MARK: - CollectionView flow layout
extension TagsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //tagsCollectionView
        let currentStringTag: String = getDisplayedTagString(index: indexPath.item)
        let stringSize = currentStringTag.sizeOfString(usingFont: UIFont.circeRegular(with: 15))
        let cellWidth = stringSize.width + FeedConstants.tagCellPadding * 2
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

