//
//  DateModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.08.2022.
//

import Foundation
import CoreData

final class DateModel {
    private let lastUpdateDateManager = LastUpdateDateManager()
    
    func lastUpdateDate() -> String {
        guard
            let lastUpdateDate = lastUpdateDateManager.fetchLastUdateDate() else {
            let defaultDate = Date(timeIntervalSince1970: 197208000) // "1 Apr 1976 12:00:00"
            lastUpdateDateManager.createLastUpdateDate(defaultDate)
            return formattedDate(date: defaultDate)
        }
        return formattedDate(date: lastUpdateDate)
    }
    
    func received(new date: Date) {
        lastUpdateDateManager.updateLastUpdateDate(with: date)
    }
    
    func minimumDate() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = -1
        let date = calendar.date(byAdding: components, to: Date())
        return date ?? Date()
    }
    
    func formattedDate(date: Date, format: String = "d MMM yyyy HH:mm") -> String {
        let dateFormaterSet = DateFormatter()
        dateFormaterSet.dateFormat = format
        
        let formattedDate = dateFormaterSet.string(from: date)
        return formattedDate
    }
    
    func checkPickerDate(_ date: Date) -> Bool { 
        return date < Calendar.current.startOfDay(for: Date())
    }
 
    func checkTimeInterval() -> Bool {
        guard let date = lastUpdateDateManager.fetchLastUdateDate() else { return true }
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: date)
        
        if
            let minutes = components.minute,
            let seconds = components.second {
            let timeInterval = -Int(date.timeIntervalSinceNow)
            if timeInterval > 3600 - (minutes * 60 + seconds) {
                return true
            }
        }
        return false
    }
}
