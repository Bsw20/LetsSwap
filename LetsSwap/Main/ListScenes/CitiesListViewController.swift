//
//  CitiesListViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.01.2021.
//

import Foundation
import UIKit

class CitiesListViewController: UIViewController {
    
    //MARK: - Controls
    private var selectedTags: Set<FeedTag>  = []
    private var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        
//        self.tabBarController?.tabBar.isHidden = true
//        hidesBottomBarWhenPushed = true
//        extendedLayoutIncludesOpaqueBars = true

        setupCollectionView()
        setupConstraints()
        setupNavigationController()
    }
    private func setupNavigationController() {
        navigationItem.title = "Выбери тэги"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "goBackIcon"), style: .plain, target: self, action: #selector(leftBarButtonTapped)), animated: true)
        navigationItem.hidesBackButton = true
    }
    
    @objc private func leftBarButtonTapped() {
        print("left bar button tapped")
        navigationController?.popViewController(animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
    }
}

//MARK: - CollectionDelegate&DataSource
extension CitiesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        print("select at \(indexPath)")
        print("add \(FeedTag.allCases[indexPath.item])")
        selectedTags.insert(FeedTag.allCases[indexPath.item])
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setSelected()
        
        print(selectedTags)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselect at \(indexPath)")
        print("remove \(FeedTag.allCases[indexPath.item])")
        selectedTags.remove(FeedTag.allCases[indexPath.item])
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setDeselected()
        print(selectedTags)
//        collectionView.reloadData()
    }
    
    
}

//MARK: - FlowLayoutDelegate
extension CitiesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 54)
    }
}

//MARK: - Constraints
extension CitiesListViewController {
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


