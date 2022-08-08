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
    
    func lastUpdateDate() -> Date {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bulletin")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["date"]
        
        guard
            let result = try? coreDataStack.managedContext.fetch(fetchRequest),
            let firstResult = result.first,
            let dictionary = firstResult as? [String: Date],
            let date = dictionary["date"] else {
            return Date(timeIntervalSince1970: 197208000)// "1 Apr 1976 12:00:00"
        }
        return date
    }
    
    func formattedDate() -> String {
        let dateFormaterSet = DateFormatter()
        dateFormaterSet.dateFormat = "d MMM yyyy HH:mm"
        
        let formattedDate = dateFormaterSet.string(from: lastUpdateDate())
        return formattedDate
    }
    
    func checkLastUpdateDate() -> Bool {
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
