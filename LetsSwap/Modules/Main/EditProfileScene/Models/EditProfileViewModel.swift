//
//  EditProfileViewModel.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 01.02.2021.
//

import Foundation
import UIKit

struct EditProfileViewModel: Decodable {
    var name: String
    var lastname: String
    var city: String
    var login: String
    var url: String?
    
    var representation: [String: Any] {
        var rep = ["name": name]
        rep["lastname"] = lastname
        rep["city"] = city
        rep["login"] = login
        rep["url"] = url ?? ""
        return rep
    }
}

