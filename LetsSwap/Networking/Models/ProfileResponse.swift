//
//  ProfileResponse.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

struct ProfileResponse: Decodable {
    var userId: Int
    var userDescription: ProfileDescription
    var feedResponse: FeedResponse
}

struct ProfileDescription: Decodable {
    var userPhoto: Photo?
    var swapsCount: Int
    var rating: Double
    var name: String
    var lastName: String
    var cityName: String
}

