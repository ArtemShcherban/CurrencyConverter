//
//  DateModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.08.2022.
//

import Foundation

final class DateModel {
    private let lastUpdateDateRepository = LastUpdateDateRepository(CoreDataStack.shared)
    
    func lastUpdateDate() -> String {
        guard
            let lastUpdateDate = lastUpdateDateRepository.date else {
            let defaultDate = Date(timeIntervalSince1970: 197208000) // "1 Apr 1976 12:00:00"
            lastUpdateDateRepository.create(lastUpdateDate: defaultDate)
            
            return defaultDate.dMMMyyyyHHmm
        }
        return lastUpdateDate.dMMMyyyyHHmm
    }
    
    func renew(updateDate: Date) {
        if updateDate < Date().startOfDay { return }
        lastUpdateDateRepository.update(with: updateDate)
    }
    
    func checkPickerDate(_ date: Date) -> Bool {
        return date < Calendar.current.startOfDay(for: Date())
    }
    
    func checkTimeInterval(to date: Date) -> Bool {
        if date < Date().startOfDay {
            return true }
        guard let lastUpdateDate = lastUpdateDateRepository.date else {
            return true }
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: lastUpdateDate)
        if
            let minutes = components.minute,
            let seconds = components.second {
            let timeInterval = -Int(lastUpdateDate.timeIntervalSinceNow)
            if timeInterval > 3600 - (minutes * 60 + seconds) {
                return true
            }
        }
        return false
    }
    
    func nextUpdateHour(from date: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .current, from: date)
        if let hour = components.hour {
            return hour + 1
        } else {
            return nil
        }
    }
}
