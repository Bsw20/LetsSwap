//
//  NotificationCollectionView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//

import Foundation
import UIKit
import SwiftyBeaver

protocol NotificationCollectionViewDelegate {
    func routeToChat()
    func showAlert(title: String, message: String)
}


class NotificationCollectionView: UICollectionView {
    typealias NotificationModel = SwapNotification.AllNotifications.ViewModel
    //MARK: - Variables
    private var service: SwapsFetcher = SwapsManager()
    private var notifications: NotificationModel = NotificationModel(offers: []) {
        didSet {
            reloadData()
        }
    }
    public var customDelegate: NotificationCollectionViewDelegate?

    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        backgroundColor = .mainBackground()
        dataSource = self
        delegate = self
        register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(notifications: NotificationModel) {
        self.notifications = notifications
    }
}

//MARK: - Delegate&DataSource
extension NotificationCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.reuseId, for: indexPath) as! NotificationCell
        cell.set(notificationType: .mvpVersion(model: notifications.offers[indexPath.item]))
        cell.customDelegate = self
        return cell
    }
}

//MARK: - CollectionView flow layout
extension NotificationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - NotificationSceneConstants.leadingTrailingOffset * 2
        let height:CGFloat = 210
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: NotificationSceneConstants.topOffset,
                            left: NotificationSceneConstants.leadingTrailingOffset,
                            bottom: 0,
                            right: NotificationSceneConstants.leadingTrailingOffset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return NotificationSceneConstants.interitemSpacing
    }
}

//MARK: - NotificationCellDelegate
extension NotificationCollectionView: NotificationCellDelegate {
    func refuseButtonTapped(cell: NotificationCell) {
        print("refuse")
        guard let ip = indexPath(for: cell) else {
            SwiftyBeaver.error("Can't find cell")
            fatalError("Can't find cell")
        }
        service.refuseSwap(swapId: notifications.offers[ip.item].swapId) { (result) in
            switch result {
            
            case .success():
                self.notifications.offers.remove(at: ip.item)
            case .failure(let error):
                self.customDelegate?.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    
    func swapButtonTapped(cell: NotificationCell) {
        print("swap")
        print(indexPath(for: cell))
        if let ip = indexPath(for: cell) {
            service.confirmSwap(swapId: notifications.offers[ip.item].swapId) { (result) in
                switch result {
                
                case .success():
                    self.service.createChat(userId: self.notifications.offers[ip.item].userId) { (result) in
                        switch result {
                        
                        case .success():
                            self.notifications.offers.remove(at: ip.item)
                        case .failure(let error):
                            #warning("В будущем showAlert")
                            self.notifications.offers.remove(at: ip.item)
//                            self.customDelegate?.showAlert(title: "Ошибка!", message: error.localizedDescription)
                            break
                        }
                    }
                case .failure(let error):
                    self.customDelegate?.showAlert(title: "Ошибка!", message: "Не получилось подтвердить мах.")
                }
            }
        }
    }
    
    
}

// MARK: - SwiftUI
import SwiftUI

struct NotificationCollectionProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notifVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return notifVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

