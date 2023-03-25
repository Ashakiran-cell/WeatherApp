//
//  Network+Helper.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

protocol NetworkProtocol {
    
    func request<T: Codable>(urlString: String, model: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void)
}
