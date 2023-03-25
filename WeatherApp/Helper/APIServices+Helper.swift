//
//  APIServices+Helper.swift
//  WeatherApp
//
//  Created by Ashakiran Thatavarthi on 24/03/23.
//

import Foundation

class APIServices: NetworkProtocol {
    
    func request<T: Codable>(urlString: String, model: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completionHandler(.failure(error))
                return
            }
            guard let data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(urlString)
                print(String(decoding: jsonData, as: UTF8.self))
                print("\n")
            }
            do {
                let jsonResult = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(jsonResult))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
