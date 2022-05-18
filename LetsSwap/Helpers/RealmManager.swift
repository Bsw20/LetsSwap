//
//  RealmManager.swift
//  LetsSwap
//
//  Created by Владимир Моторкин on 18.05.2022.
//

import Foundation
import RealmSwift

class RealmNotification: Object {
    @objc dynamic var comment = ""
    @objc dynamic var desc = ""
    @objc dynamic var image = ""
    @objc dynamic var name = ""
    @objc dynamic var lastname = ""
    @objc dynamic var orderId = 0
    @objc dynamic var status = ""
    @objc dynamic var userId = 0
    @objc dynamic var swapId = 0
}

class RealmCell: Object {
    @objc dynamic var orderId = 0
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var counterOffer = ""
    @objc dynamic var photoStringURL = ""
    @objc dynamic var isFavourite = true
    @objc dynamic var isFree = false
}



class RealmManager {
    public static let shared = RealmManager()
    
    func saveFavorites(feedViewModel: FeedViewModel) {
        onMainThread {
            let realm = try! Realm()
            let allObjects = realm.objects(RealmCell.self)
            try! realm.write() {
                realm.delete(allObjects)
                for cell in feedViewModel.cells {
                    let realmCell = self.cellToRealm(cell: cell)
                    realm.add(realmCell)
                }
            }
        }
    }
    
    func saveNotifications(notifications: SwapNotification.AllNotifications.ViewModel) {
        onMainThread {
            let realm = try! Realm()
            let allObjects = realm.objects(RealmNotification.self)
            try! realm.write() {
                realm.delete(allObjects)
                for notification in notifications.offers {
                    let realmNotification = self.notificationToRealm(notification: notification)
                    realm.add(realmNotification)
                }
            }
        }
    }
    
    func loadFavorites() -> FeedViewModel {
        let realm = try! Realm()
        let realmCells = realm.objects(RealmCell.self)
        var cells: [FeedViewModel.Cell] = []
        for realmCell in realmCells {
            cells.append(realmToCell(realmCell: realmCell))
        }
        let feedViewModel = FeedViewModel.init(cells: cells)
        return feedViewModel
    }
    
    func loadNotifications() -> SwapNotification.AllNotifications.ViewModel {
        let realm = try! Realm()
        let realmNotifications = realm.objects(RealmNotification.self)
        var notifications: [SwapNotification.AllNotifications.Notification] = []
        for realmNotification in realmNotifications {
            notifications.append(realmToNotification(realmNotification: realmNotification))
        }
        let viewModel = SwapNotification.AllNotifications.ViewModel.init(offers: notifications)
        return viewModel
    }
    
    func deleteAllData() {
        let realm = try! Realm()
        try! realm.write() {
            realm.deleteAll()
        }
    }
    
    private func notificationToRealm(notification: SwapNotification.AllNotifications.Notification) -> RealmNotification {
        let realmNotification = RealmNotification()
        realmNotification.comment = notification.comment
        realmNotification.desc = notification.description
        realmNotification.image = notification.image ?? ""
        realmNotification.name = notification.name
        realmNotification.lastname = notification.lastname
        realmNotification.orderId = notification.orderId
        realmNotification.status = notification.status
        realmNotification.userId = notification.userId
        realmNotification.swapId = notification.swapId
        return realmNotification
    }
    
    private func realmToNotification(realmNotification: RealmNotification) -> SwapNotification.AllNotifications.Notification {
        let imageURL = realmNotification.image.isEmpty ? nil : ""
        let notification = SwapNotification.AllNotifications.Notification.init(comment: realmNotification.comment, description: realmNotification.desc, image: imageURL, name: realmNotification.name, lastname: realmNotification.lastname, orderId: realmNotification.orderId, status: realmNotification.status, userId: realmNotification.userId, swapId: realmNotification.swapId)
        return notification
    }
    
    private func cellToRealm(cell: FeedViewModel.Cell) -> RealmCell {
        let realmCell = RealmCell()
        realmCell.orderId = cell.orderId
        realmCell.title = cell.title
        realmCell.desc = cell.description
        realmCell.counterOffer = cell.counterOffer
        realmCell.photoStringURL = cell.photo?.absoluteString ?? ""
        realmCell.isFavourite = cell.isFavourite
        realmCell.isFree = cell.isFree
        return realmCell
    }
    
    private func realmToCell(realmCell: RealmCell) -> FeedViewModel.Cell {
        let cell = FeedViewModel.Cell.init(orderId: realmCell.orderId, title: realmCell.title, description: realmCell.desc, counterOffer: realmCell.counterOffer, photo: realmCell.photoStringURL.isEmpty ? nil : URL(string: realmCell.photoStringURL), isFavourite: realmCell.isFavourite, isFree: realmCell.isFree)
        return cell
    }
}
