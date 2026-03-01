//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Александр Клопков on 23.02.2026.
//

import Foundation

struct WeatherForecastResponse: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let localTime: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case localTime = "localtime"
    }
}

struct Current: Decodable {
    let tempC: Double
    let windKph: Double
    let windDir: String
    
    private enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case windKph = "wind_kph"
        case windDir = "wind_dir"
    }
}

struct Forecast: Decodable {
    let forecastDay: [ForecastDay]
    
    private enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Decodable {
    let maxTempC: Double
    let minTempC: Double
    let maxWindKph: Double
    
    private enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case minTempC = "mintemp_c"
        case maxWindKph = "maxwind_kph"
    }
}

struct Hour: Decodable {
    let time: String
    let tempC: Double
    let windKph: Double
    let windDir: String
    
    private enum CodingKeys: String, CodingKey {
        case time = "time"
        case tempC = "temp_c"
        case windKph = "wind_kph"
        case windDir = "wind_dir"
    }
}
