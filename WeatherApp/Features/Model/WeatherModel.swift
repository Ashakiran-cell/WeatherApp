//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let name: String?
    let lat, lon: Double?
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
    
    init(name: String?, lat: Double?, lon: Double?, country: String?, state: String?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
}
