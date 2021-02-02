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
    private var feedViewModel = MyProfileViewModel.FeedModel.init(cells: [
                                                                    MyProfileViewModel.FeedModel.Cell.init(orderId: 123, title: "Научу писать продающие тексты для инстаграма", description: "Научу их писать", counterOffer: "В обмен хочу чтобы ты решил за меня линал", photo: nil, isFree: false, isHidden: false),
        
        MyProfileViewModel.FeedModel.Cell.init(orderId: 2, title: "Научу плавать", description: "Занимаюсь плаваньем профессионально 10 лет", counterOffer: "Научите меня играть на гитаре", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: false),
        
        MyProfileViewModel.FeedModel.Cell.init(orderId: 4, title: "Научу кататься на борде", description: "Катаю с детства, знаю огромное количество трюков, обожаю фрирайд, люблю экстримальные виды спорта, а также прогать; Увлекаюсь математикой, поэтому по ходу помогу выучить линал; Да когда эта лента уже закончится ", counterOffer: "Научите меня серфить", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: false, isHidden: true),
        MyProfileViewModel.FeedModel.Cell.init(orderId: 2, title: "Научу плавать", description: "Занимаюсь плаваньем профессионально 10 лет", counterOffer: "Научите меня играть на гитаре", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: false),
        
        MyProfileViewModel.FeedModel.Cell.init(orderId: 4, title: "Научу кататься на борде", description: "Катаю с детства, знаю огромное количество трюков, обожаю фрирайд, люблю экстримальные виды спорта, а также прогать; Увлекаюсь математикой, поэтому по ходу помогу выучить линал; Да когда эта лента уже закончится ", counterOffer: "Научите меня серфить", photo: URL(string: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album"), isFree: true, isHidden: true)
    ])
    
    init() {

        super.init(frame: .zero, collectionViewLayout: FeedCollectionLayout.createCompositionalLayout())
        delegate = self
        dataSource = self
        backgroundColor = .mainBackground()
        register(CreateOrderCell.self, forCellWithReuseIdentifier: CreateOrderCell.reuseId)
        register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseId)
        allowsMultipleSelection = false
        semanticContentAttribute = .forceRightToLeft
        
    }
    
    public func updateData(feedViewModel: MyProfileViewModel.FeedModel) {
//        self.feedViewModel = feedViewModel
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - DataSource
extension MyProfileFeedCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.cells.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = self.dequeueReusableCell(withReuseIdentifier: CreateOrderCell.reuseId, for: indexPath) as! CreateOrderCell
            cell.delegate = self
            return cell
        }
        let cellModel = feedViewModel.cells[indexPath.item - 1] //Тк на одну ячейку больше из-за CreateOrderCell
        let cell = self.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        cell.set(cellType: FeedCell.FeedCellType.myProfileCell(cellViewModel: cellModel), indexPath: indexPath)
        return cell
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
            myProfileDelegate?.openOrderCellTapped(orderId: feedViewModel.cells[indexPath.item - 1].orderId)
            print(indexPath)
        }
    }
}
