//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Александр Клопков on 23.02.2026.
//

import Foundation

enum WeatherError: Error {
    case invalidURL
    case decodingError
    case networkError(String)
    case serverError(Int)
}

class WeatherService {
    private let apiKey = ""
    private let baseURL = "https://api.weatherapi.com/v1/"
    
    
    func fetchCurrentWeather(with lat: String, and lon: String) async throws -> CurrentWeatherForecastResponse {
        let url = URL(string: "\(baseURL)current.json?key=\(apiKey)&q=\(lat),\(lon)")
        guard let url else {
            throw WeatherError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.networkError("Incorrect answer from server")
            }
            switch httpResponse.statusCode {
            case 200...299:
                break
            default:
                throw WeatherError.serverError(httpResponse.statusCode)
            }
            
            do {
                let decode = try JSONDecoder().decode(CurrentWeatherForecastResponse.self, from: data)
                return decode
            } catch {
                throw WeatherError.decodingError
            }
        } catch {
            throw WeatherError.networkError(error.localizedDescription)
        }
    }
}
