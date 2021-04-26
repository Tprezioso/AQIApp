//
//  AQData.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/25/21.
//

import Foundation

struct AQData: Codable {
    var status: String
    var data: DataParse
}

struct DataParse: Codable {
    var city: City
    var aqi: Int
}

struct City: Codable {
    var name: String
}
