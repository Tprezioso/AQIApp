//
//  AQData.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/25/21.
//

import Foundation

struct AQData: Codable {
    var geo: [Double]?
    var name: String?
    var iaqi: [String : Double]?
    
}
