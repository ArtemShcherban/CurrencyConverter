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
    
    var dMMMyyyyHHmm: String {
        return formattedDate(date: self, format: "d MMM yyyy HH:mm")
    }
    
    private func formattedDate(date: Date, format: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        
        let formattedDate = dateFormater.string(from: date)
        return formattedDate
    }
}
