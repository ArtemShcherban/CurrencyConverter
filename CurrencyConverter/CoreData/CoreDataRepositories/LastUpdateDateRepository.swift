//
//  LastUpdateDateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation
import CoreData

protocol LastUpdateDateRepository {
    func create(lastUpdateDate: Date)
    func get() -> Date?
    func update(with lastUpdateDate: Date)
}

struct LastUpdateDateDataRepository: LastUpdateDateRepository {
    let coreDataStack = CoreDataStack.shared
    
    func create(lastUpdateDate: Date) {
        let cdLastUpdateDate = CDLastUpdateDate(context: coreDataStack.managedContext)
        cdLastUpdateDate.date = lastUpdateDate
        coreDataStack.saveContext()
    }
    
    func get() -> Date? {
        guard let cdLastUpdateDate = getCDLastUpdateDate() else { return nil }
        return cdLastUpdateDate.date
    }
    
    func update(with lastUpdateDate: Date) {
        guard let cdLastUpdateDate = getCDLastUpdateDate() else { return }
        cdLastUpdateDate.date = lastUpdateDate
        coreDataStack.saveContext()
    }
    
    private func getCDLastUpdateDate() -> CDLastUpdateDate? {
        guard
            let result = coreDataStack.fetchManagedObject(managedObject: CDLastUpdateDate.self),
            let cdLastUpdateDate = result.first else {
            return nil
        }
        return cdLastUpdateDate
    }
}
