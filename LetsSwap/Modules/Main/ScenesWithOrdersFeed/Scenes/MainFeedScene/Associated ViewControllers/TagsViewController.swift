//
//  TagsViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 19.12.2020.
//

import Foundation
import UIKit
import Tags

protocol AllTagsListDelegate: NSObjectProtocol {
    func tagsSelected(tags: Set<FeedTag>)
}

class TagsViewController: UIViewController {
    private var displayedTags = FeedTag.allCases
    var selectedTags = Set<FeedTag>()
    var delegate: AllTagsListDelegate!
    private let tagsView = TagsView()
    private let allTags: [FeedTag] = FeedTag.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        self.navigationController?.navigationBar.tintColor = .black
        setupTags()
        setupTagsView()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.tagsSelected(tags: selectedTags)
    }
    
    func setupTagsView() {
        tagsView.delegate = self
        tagsView.backgroundColor = .mainBackground()
        tagsView.tagBackgroundColor = .mainBackground()
        tagsView.tagLayerRadius = 21
        tagsView.tagLayerWidth = 1
        tagsView.tagLayerColor = UIColor.mainYellow()
        tagsView.clipsToBounds = true
        tagsView.paddingHorizontal = 20
        tagsView.paddingVertical = 6
        tagsView.tagFont = UIFont.circeRegular(with: 19)
        tagsView.tagTitleColor = .mainTextColor()
    }
    
    func setupConstraints() {
        self.view.addSubview(tagsView)
        tagsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tagsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //tagsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTags() {
        tagsView.append(contentsOf: allTags.map({ $0.rawValue }))
        for tag in selectedTags {
            if let index = allTags.firstIndex(of: tag) {
                let tagButton = TagButton()
                tagButton.setTitle(tag.rawValue, for: .normal)
                let options = ButtonOptions(
                    layerColor: UIColor.mainYellow(), // layer Color
                    layerRadius: 21, // layer Radius
                    layerWidth: 1, // layer Width
                    tagTitleColor: UIColor.white, // title Color
                    tagFont: UIFont.circeRegular(with: 19), // Font
                    tagBackgroundColor: UIColor.mainYellow() // Background Color
                )
                tagButton.setEntity(options)
                tagsView.update(tagButton, at: index)
            }
        }
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

extension TagsViewController: TagsDelegate{

    // Tag Touch Action
    func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
        let tag = allTags[tagButton.index]
        if selectedTags.contains(tag) {
            tagButton.backgroundColor = .mainBackground()
            tagButton.setTitleColor(.mainTextColor(), for: .normal)
            selectedTags.remove(tag)
        } else {
            tagButton.backgroundColor = .mainYellow()
            tagButton.setTitleColor(.white, for: .normal)
            selectedTags.insert(tag)
        }
    }
    
    // Last Tag Touch Action
    func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
    
    }
    
    // TagsView Change Height
    func tagsChangeHeight(_ tagsView: TagsView, height: CGFloat) {
    
    }
}
