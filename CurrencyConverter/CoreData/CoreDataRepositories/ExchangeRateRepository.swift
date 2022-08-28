//
//  ExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation
import CoreData

protocol ExchangeRateRepository {
    func create(exchangeRate: ExchangeRate)
    func getAll() -> [ExchangeRate]?
    func get(byCurrency number: Int16) -> ExchangeRate?
    func update(exchangeRate: ExchangeRate)
    func delete(byCurrency number: Int16)
}

struct ExchangeRateDataRepository: ExchangeRateRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func create(exchangeRate: ExchangeRate) {
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
        cdExchangeRate.currencyNumber = Int16(exchangeRate.currencyNumber)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
    
    func getAll() -> [ExchangeRate]? {
        return nil
    }
    
    func get(byCurrency number: Int16) -> ExchangeRate? {
        guard let cdExchangeRate = getCDExchangeRate(byCurrency: number) else { return nil }
        
        return cdExchangeRate.convertToExchangeRate()
    }
    
    func update(exchangeRate: ExchangeRate) {
    }
    
    func delete(byCurrency number: Int16) {
    }
    
    private func getCDExchangeRate(byCurrency number: Int16) -> CDExchangeRate? {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDExchangeRate.currencyNumber), number)
        fetchRequest.predicate = predicate
        
        guard
            let result = try? coreDataStack.managedContext.fetch(fetchRequest),
            let cdExchangeRate = result.first else {
            return nil
        }
        return cdExchangeRate
    }
}
