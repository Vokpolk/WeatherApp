//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Александр Клопков on 23.02.2026.
//

import Foundation

/// текущая погода
struct CurrentWeatherForecastResponse: Decodable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
}

struct CurrentWeather: Decodable {
    let tempC: Double
    let windKph: Double
    let windDir: String
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case windKph = "wind_kph"
        case windDir = "wind_dir"
    }
}

/// почасовой прогноз погоды
struct HorlyWeatherForecastResponse {
    
}

/// прогноз погоды на 3 дня
struct ThreeDaysWeatherForecastResponse {
    
}
