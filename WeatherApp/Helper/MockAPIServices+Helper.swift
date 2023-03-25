//
//  MockAPIServices+Helper.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

class MockAPIServices: NetworkProtocol {
    
    func request<T: Codable>(urlString: String, model: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        if let url = Bundle.main.url(forResource: urlString, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                completionHandler(.success(jsonData))
            } catch {
                print("error:\(error)")
                completionHandler(.failure(error))
            }
        }
    }
}
