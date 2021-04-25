//
//  AQIError.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/25/21.
//

import Foundation

enum AQIError : String, Error {
    case invalidURL = "This URL was invaild request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the sever was invalid. Please try again"
    case unableToFavorite = "There was an error favoriting this user please try again"
    case alreadyInFavorites = "You already favorited this person"
}
