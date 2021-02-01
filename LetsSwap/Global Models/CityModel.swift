//
//  CityModel.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.01.2021.
//

import Foundation
import UIKit

struct City: Codable, Equatable {
    let region: String
    let city: String
    
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.city == rhs.city && lhs.city == rhs.city
    }
    
    static func getCities() -> [String]{
        //    var countryCodes = CountryCodes()
        
        do {

             let url = Bundle.main.url(forResource: "russia", withExtension: "json")!
             let data = try Data(contentsOf: url)
             let res = try JSONDecoder().decode([City].self, from: data)
            let cities = res.map {$0.city}
            return cities
        }
        catch {
            print(error)
        }
        return []
    }
    
    static func getCitiesModel() -> [City]{
        
        do {

             let url = Bundle.main.url(forResource: "russia", withExtension: "json")!
             let data = try Data(contentsOf: url)
             let res = try JSONDecoder().decode([City].self, from: data)
            return res
        }
        catch {
            print(error)
        }
        return []
    }
    
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        
        if filter.isEmpty {
            return true
        }
        
        let lowercasedFilter = filter.lowercased()
        return city.lowercased().contains(lowercasedFilter)
    }
}




