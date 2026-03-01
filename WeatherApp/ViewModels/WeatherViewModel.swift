//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Александр Клопков on 24.02.2026.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel {
    
    // MARK: - Private Properties
    private let weatherService: WeatherService = WeatherService()
    private let locationService: LocationService = LocationService.shared
    private(set) var model: WeatherForecastResponse?
    
    private(set) var cellModels: [WeatherCellModel] = []
    
    private var isFetching = false
    
    // MARK: - Callbacks
    var onLocationRequestStarted: (() -> Void)?
    var onLocationRequestFinished: (() -> Void)?
    var onWeatherLoaded: ((WeatherForecastResponse) -> Void)?
    var onCellsUpdated: (() -> Void)?
    var onError: ((String, String, @escaping () -> Void) -> Void)?
    
    // MARK: - Public Methods
    func start() {
        onLocationRequestStarted?()
        locationService.requestLocation { [weak self] location in
            self?.handleLocation(location)
        }
    }
    
    // MARK: - Private Methods
    private func handleLocation(_ location: CLLocation) {
        onLocationRequestFinished?()
        
        Task {
            await fetchWeather(
                with: String(location.coordinate.latitude),
                and: String(location.coordinate.longitude)
            )
        }
    }
    
    private func fetchWeather(with lat: String, and lon: String) async {
        guard !isFetching else { return }
        
        isFetching = true
        
        do {
            print("lat: \(lat), lon: \(lon)")
            model = try await weatherService.fetchWeatherForecast(
                with: lat,
                and: lon
            )
            guard let model else { return }
            updateCellModels(with: model)
            onWeatherLoaded?(model)
        } catch {
            print(error.localizedDescription)
            handleError(error)
        }
        
        isFetching = false
    }
    
    private func updateCellModels(with weather: WeatherForecastResponse) {
        var isCurrentTime = false
        var daysCount = 2
        for day in weather.forecast.forecastDay {
            if daysCount == 0 {
                break
            }
            for hour in day.hour {
                if weather.location.localTime < hour.time {
                    isCurrentTime = true
                }
                if isCurrentTime == true {
                    let tempCell = WeatherCellModel(
                        date: day.date.toDisplayDate(),
                        time: hour.time.toDisplayTime(),
                        tempC: hour.tempC
                    )
                    cellModels.append(tempCell)
                }
            }
            daysCount -= 1
        }
        onCellsUpdated?()
    }
    
    private func handleError(_ error: Error) {
        let title: String
        let message: String
        
        if let error = error as? WeatherError {
            switch error {
            case .invalidURL:
                title = "Ошибка"
                message = "Неверный URL"
            case .decodingError:
                title = "Ошибка"
                message = "Не удалось обработать данные с сервера"
            case .networkError(let msg):
                title = "Ошибка"
                message = "Нет соединения с интернетом. \(msg)"
            case .serverError(let code):
                title = "Ошибка"
                message = "Результат запроса \(code)"
            }
        } else {
            title = "Ошибка"
            message = error.localizedDescription
        }
        
        onError?(title, message) { [weak self] in
            self?.start()
        }
    }
}
