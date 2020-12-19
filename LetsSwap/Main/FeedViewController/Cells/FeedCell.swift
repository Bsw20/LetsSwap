//
//  FeedCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

protocol FeedCellViewModel {
    var title: String { get }
    var description: String { get }
    var counterOffer: String { get }
    var photo: URL? { get }
    var isFavourite: Bool { get }
    var isFree: Bool { get }
}

final class FeedCell: UITableViewCell {
    static let reuseId = "FeedCell"
}
