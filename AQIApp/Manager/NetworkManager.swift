//
//  NetworkManager.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/25/21.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let token = "41fee90aad3e3ecfc4d8c52666f33cab98e0d2ca"
    private init() {}
    let baseURL = "https://api.waqi.info/feed/"
    
    func getAirQualityData(lat: String, lon: String, completed: @escaping (Result<AQData, AQIError>) -> Void) {
        let airQualityURL = baseURL + "geo:\(lat);\(lon)/?token=\(token)"
        guard let url = URL(string: airQualityURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(AQData.self, from: data)
                    completed(.success(user))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }
    
}
    

