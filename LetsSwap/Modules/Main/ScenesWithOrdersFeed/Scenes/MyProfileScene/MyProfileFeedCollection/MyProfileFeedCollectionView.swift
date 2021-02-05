//
//  MyProfileFeedCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.01.2021.
//

import Foundation
import UIKit

protocol MyProfileFeedCollectionViewDelegate: NSObjectProtocol {
    func createOrderCellTapped()
    func openOrderCellTapped(orderId: Int)
}

class MyProfileFeedCollectionView: UICollectionView {
    weak var myProfileDelegate: MyProfileFeedCollectionViewDelegate?
    private var feedViewModel = MyProfileViewModel(
        personInfo: MyProfileViewModel.PersonInfo.init(profileImage: "", name: "", lastname: "", cityName: "", swapsCount: 0, raiting: 0),
        feedInfo: MyProfileViewModel.FeedModel.init(cells: []))
    
    init() {
        let layout = FeedCollectionLayout.createCompositionalLayout(supplementaryViews: [
            FeedCollectionLayout.createSectionHeader()
//            FeedCollectionLayout.createSectionFooter()
        ])
        super.init(frame: .zero, collectionViewLayout:layout )
        delegate = self
        dataSource = self
        backgroundColor = .mainBackground()
        register(CreateOrderCell.self, forCellWithReuseIdentifier: CreateOrderCell.reuseId)
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        register(MyProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyProfileHeaderView.reuseId)
        allowsMultipleSelection = false
        semanticContentAttribute = .forceRightToLeft
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
    }
    
    public func updateData(feedViewModel: MyProfileViewModel) {
        self.feedViewModel = feedViewModel
        reloadData()
    }
    public func updateData(feedModel: MyProfileViewModel.FeedModel) {
        self.feedViewModel.feedInfo = feedModel
        reloadData()
    }
    public func updateData(personInfo: MyProfileViewModel.PersonInfo) {
        self.feedViewModel.personInfo = personInfo
        reloadData()
    }
    
//    private func getHeight() -> CGFloat {
//        return 0
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - DataSource
extension MyProfileFeedCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.feedInfo.cells.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = self.dequeueReusableCell(withReuseIdentifier: CreateOrderCell.reuseId, for: indexPath) as! CreateOrderCell
            cell.delegate = self
            return cell
        }
        let cellModel = feedViewModel.feedInfo.cells[indexPath.item - 1] //Тк на одну ячейку больше из-за CreateOrderCell
        let cell = self.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        cell.set(cellType: FeedCell.FeedCellType.myProfileCell(cellViewModel: cellModel), indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyProfileHeaderView.reuseId, for: indexPath) as? MyProfileHeaderView else { fatalError("Can not create new section header") }
            sectionHeader.configure(model: feedViewModel.personInfo)
            return sectionHeader
            #warning("ДОДЕЛАТЬ ФУТТЕР")
        } else if kind == UICollectionView.elementKindSectionFooter {
            fatalError("Такого supplementaryView не должно быть в данной коллекции")
        } else {
            fatalError("Такого supplementaryView не должно быть в данной коллекции")
        }
    }
}


//MARK: - CreateOrderCellDelegate
extension MyProfileFeedCollectionView: CreateOrderCellDelegate {
    func createOrderButtonTapped() {
        myProfileDelegate?.createOrderCellTapped()
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension MyProfileFeedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item != 0 {
            myProfileDelegate?.openOrderCellTapped(orderId: feedViewModel.feedInfo.cells[indexPath.item - 1].orderId)
            print(indexPath)
        }
    }
}
