//
//  WeatherApiConnecter.swift
//  Lab08
//
//  Created by Yash Suthar on 2024-11-17.
//

import Foundation

/// A service class to handle weather data fetching using the OpenWeatherMap API.
class WeatherService {
    
    // MARK: - Properties
    private let apiKey = "6ee11ead4ef2ce6f07b8f3212afdff36" // Replace with your actual API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather" // Base URL for OpenWeatherMap API
    
    // MARK: - Methods
    /// Fetches weather data for a given latitude and longitude.
    /// - Parameters:
    ///   - latitude: Latitude of the location.
    ///   - longitude: Longitude of the location.
    ///   - completion: Completion handler returning a `WeatherModel` or `nil` if the request fails.
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherModel?) -> Void) {
        // Construct the full API URL with query parameters
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil) // Return nil if the URL is invalid
            return
        }
        
        // Create and start a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle any errors during the request
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Ensure data is returned from the API
            guard let data = data else {
                print("No data returned from API")
                completion(nil)
                return
            }
            
            // Decode the JSON response into a WeatherModel
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                completion(weatherData) // Pass the decoded weather data to the completion handler
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil) // Return nil if JSON decoding fails
            }
        }
        task.resume() // Start the network call
    }
}
