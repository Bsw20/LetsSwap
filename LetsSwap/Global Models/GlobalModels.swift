//
//  GlobalModels.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

struct ProfileViewModel {
    var userId: Int
    var feedViewModel: FeedViewModel
    var profileDescription: ProfileDescriptionViewModel
}

struct ProfileDescriptionViewModel {
    var userPhoto: URL?
    var swapsCount: Int
    var rating: Double
    var name: String
    var lastName: String
    var cityName: String
}
