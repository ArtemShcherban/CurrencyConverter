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
    func delete(byCurrency number: Int16)
    func update(exchangeRate: ExchangeRate)
}

struct ExchangeRateDataRepository: ExchangeRateRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func create(exchangeRate: ExchangeRate) {
        let currencyNumber = exchangeRate.currencyNumber
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
        cdExchangeRate.currencyNumber = Int16(currencyNumber)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
    
    func getAll() -> [ExchangeRate]? {
        return nil
    }
    
    func get(byCurrency number: Int16) -> ExchangeRate? {
        guard let cdExchangeRate = getCDExchangeRate(byCurrency: number) else { return nil }
        let exchangeRate = ExchangeRate(
            buy: cdExchangeRate.buy,
            sell: cdExchangeRate.sell,
            currencyNumber: Int(cdExchangeRate.currencyNumber))
        return exchangeRate
    }
    
    func delete(byCurrency number: Int16) {
    }
    
    func update(exchangeRate: ExchangeRate) {
    }
    
    func getCDExchangeRate(byCurrency number: Int16) -> CDExchangeRate? {
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
