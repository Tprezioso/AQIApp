//
//  NetworkManager.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/25/21.
//

import UIKit
import CoreLocation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let token = "41fee90aad3e3ecfc4d8c52666f33cab98e0d2ca"
    private init() {}
    
    let baseURL = "https://api.waqi.info/feed/"
    
    func getAirQuality(lat: String, lon: String, completed: @escaping (Result<AQData, AQIError>) -> Void) {
        let appetizerURL = baseURL + "geo:\(lat);\(lon)/?token=\(token)"
        guard let url = URL(string: appetizerURL) else {
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
    
    func work(lat: String, lon: String) {
            // Create URL
            let url = URL(string: "https://api.waqi.info/feed/geo:\(lat);\(lon)/?token=\(token)")
            guard let requestUrl = url else { fatalError() }
            // Create URL Request
            var request = URLRequest(url: requestUrl)
            // Specify HTTP Method to use
            request.httpMethod = "GET"
            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                // Check if Error took place
                if let error = error {
                    print("Error took place \(error)")
                    return
                }

                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }

                // Convert HTTP Response Data to a simple String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let airQ = try? JSONDecoder().decode(AQData.self, from: data)
                    print(airQ)
                    print("Response data string:\n \(dataString)")
                }

            }
            task.resume()
        }

    }
    

