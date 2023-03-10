//
//  LastUpdateDateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation
import CoreData

protocol LastUpdateDateDataRepository {
    func create(lastUpdateDate: Date)
    var date: Date? { get }
    func update(with lastUpdateDate: Date)
}

final class LastUpdateDateRepository: Repository, LastUpdateDateDataRepository {
    func create(lastUpdateDate: Date) {
        let cdLastUpdateDate = CDLastUpdateDate(context: coreDataStack.managedContext)
        cdLastUpdateDate.date = lastUpdateDate
        coreDataStack.saveContext()
    }
    
    var date: Date? {
        guard let cdLastUpdateDate = getCDLastUpdateDate() else { return nil }
        return cdLastUpdateDate.date
    }
    
    func update(with lastUpdateDate: Date) {
        coreDataStack.managedContext.perform {
            guard let cdLastUpdateDate = self.getCDLastUpdateDate() else { return }
            cdLastUpdateDate.date = lastUpdateDate
            self.coreDataStack.saveContext()
        }
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
