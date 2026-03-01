//
//  LocationService.swift
//  WeatherApp
//
//  Created by Александр Клопков on 22.02.2026.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    // MARK: - Static Properties
    static let shared = LocationService()
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?
    
    private let moscowLocation = CLLocation(
        latitude: 55.703413,
        longitude: 37.641944
    )
    
    // MARK: - Init
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Public Methods
    func requestLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(moscowLocation)
            self.completion = nil
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            completion(moscowLocation)
            self.completion = nil
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    // MARK: - Public Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if let completion {
            switch status {
            case .restricted, .denied:
                completion(moscowLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            default:
                break
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last,
              let completion else {
            return
        }
        
        completion(location)
        self.completion = nil
        print("Current location: \(location.coordinate)")
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        if let completion {
            print("Moscow location: \(moscowLocation.coordinate)")
            completion(moscowLocation)
            self.completion = nil
        }
    }
}
