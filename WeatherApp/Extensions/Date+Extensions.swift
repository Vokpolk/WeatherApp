//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Александр Клопков on 01.03.2026.
//

import Foundation

enum DateFormatterCache {
    static let isoDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let isoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let displayTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}

extension String {
    func toDisplayTime() -> String {
        guard let date = DateFormatterCache.isoDateTime.date(from: self) else {
            return self
        }
        
        return DateFormatterCache.displayTime.string(from: date)
    }
    
    func toDisplayDate() -> String {
        guard let date = DateFormatterCache.isoDate.date(from: self) else {
            return self
        }
        
        return DateFormatterCache.displayDate.string(from: date)
    }
}
