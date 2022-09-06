//
//  DateExtensions.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var forURL: String {
        return formattedDate(date: self, format: "dd.MM.yyyy")
    }
    
    var dMMMyyy: String {
        return formattedDate(date: self, format: "d MMM yyyy")
    }
    
    var yyyyMMdd: String {
        return formattedDate(date: self, format: "yyyy-MM-dd" )
    }
    
    var dMMMyyyyHHmm: String {
        return formattedDate(date: self, format: "d MMM yyyy HH:mm")
    }
    
    var oneYearAgo: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = -1
        let date = calendar.date(byAdding: components, to: self.startOfDay) ?? Date() - 31_536_000
        return date
    }
    
    private func formattedDate(date: Date, format: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        
        let formattedDate = dateFormater.string(from: date)
        return formattedDate
    }
}
