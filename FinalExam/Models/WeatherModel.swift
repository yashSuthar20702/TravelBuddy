//
//  WeatherModel.swift
//  FinalExam
//
//  Created by Yash Suthar on 2024-12-13.
//

import Foundation

// Model for representing weather data
struct WeatherModel: Codable {
    let name: String
    let weather: [WeatherDescription]
    let main: WeatherMain
    let wind: WeatherWind
    
    // Model for the weather description (e.g., "clear sky")
    struct WeatherDescription: Codable {
        let description: String
        let icon: String
    }
    
    // Model for the main weather attributes (temperature and humidity)
    struct WeatherMain: Codable {
        let temp: Double
        let humidity: Int // Add humidity here
    }
    
    // Model for the wind speed
    struct WeatherWind: Codable {
        let speed: Double // Add wind speed here
    }
}
