//
//  TagsListViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.01.2021.
//

import Foundation
import UIKit

protocol TagsListDelegate: NSObjectProtocol {
    func selectedTagsChanged(selectedTags: [FeedTag])
}

class TagsListViewController: UIViewController {
    init(selectedTags: Set<FeedTag>) {
        self.selectedTags = Set(selectedTags)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Variables
    private var selectedTags: Set<FeedTag> = [] {
        didSet {
            customDelegate?.selectedTagsChanged(selectedTags: Array(selectedTags))
        }
    }
    weak var customDelegate: TagsListDelegate?
    //MARK: - Controls
    private var collectionView: UICollectionView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        
        self.tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true

        setupCollectionView()
        setupConstraints()
        setupNavigationController()
    }
    //MARK: - funcs
    private func setupNavigationController() {
        navigationItem.title = "Выбери тэги"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "goBackIcon"), style: .plain, target: self, action: #selector(leftBarButtonTapped)), animated: true)
        navigationItem.hidesBackButton = true
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainBackground()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(ChoosePropertyCell.self, forCellWithReuseIdentifier: ChoosePropertyCell.reuseId)
    }
    
    
    //MARK: - Objc funcs
    @objc private func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - CollectionDelegate&DataSource
extension TagsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedTag.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosePropertyCell.reuseId, for: indexPath) as! ChoosePropertyCell
        let selected = selectedTags.contains(FeedTag.allCases[indexPath.item])
        cell.set(property: FeedTag.allCases[indexPath.item].rawValue,selected: selected )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTags.insert(FeedTag.allCases[indexPath.item])
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedTags.remove(FeedTag.allCases[indexPath.item])
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setDeselected()
    }
    
    
}

//MARK: - FlowLayoutDelegate
extension TagsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 54)
    }
}

//MARK: - Constraints
extension TagsListViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
