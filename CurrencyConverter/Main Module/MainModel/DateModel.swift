//
//  DateModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.08.2022.
//

import Foundation
import CoreData

final class DateModel {
    private lazy var coreDataStack = CoreDataStack.shared
    private let lastUpdateDateManager = LastUpdateDateManager()
    
    private func lastUpdateDate() -> Date {
        guard
            let lastUpdateDate = lastUpdateDateManager.fetchLastUdateDate() else {
            let defaultDate = Date(timeIntervalSince1970: 197208000) // "1 Apr 1976 12:00:00"
            lastUpdateDateManager.create(lastUpdateDate: defaultDate)
            return defaultDate
        }
        return lastUpdateDate
    }
    
    func received(new date: Date) {
        lastUpdateDateManager.updateLastUpdateDate(with: date)
    }
    
    func formattedDate() -> String {
        let dateFormaterSet = DateFormatter()
        dateFormaterSet.dateFormat = "d MMM yyyy HH:mm"
        
        let formattedDate = dateFormaterSet.string(from: lastUpdateDate())
        return formattedDate
    }
    
    func checkTimeInterval() -> Bool {
        let date = lastUpdateDate()
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
