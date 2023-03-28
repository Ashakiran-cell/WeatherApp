//
//  Constants.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

struct Defaults {
    
    static var lastCity: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "lastCityName")
        }
        get {
            UserDefaults.standard.string(forKey: "lastCityName")
        }
    }
}

struct AppConstants {
    
     static let appID = "ef7aef1084fb169cf87ad4514dce37c4"
}

struct AppURL {
    
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    static let geoURL = "http://api.openweathermap.org/geo/1.0/direct?q="
    static let forecastURL = "http://api.openweathermap.org/data/2.5/forecast?"
}
