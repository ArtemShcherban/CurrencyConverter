//
//  HistoricalRateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation
import CoreData

protocol HistoricalRateRepository {
    func create(historicalRate: HistoricalRate)
    func get(by data: Date, currency: Currency) -> HistoricalRate?
}

struct HistoricalRateDataRepository: HistoricalRateRepository {
    let coreDataStack = CoreDataStack.shared
    
    func create(historicalRate: HistoricalRate) {
        let cdHistoricalRate = CDHistoricalRate(context: coreDataStack.managedContext)
        cdHistoricalRate.buy = historicalRate.buy
        cdHistoricalRate.sell = historicalRate.sell
        cdHistoricalRate.currencyNumber = historicalRate.currencyNumber
    }
    
    func get(by data: Date, currency: Currency) -> HistoricalRate? {
        return nil
    }
    
    private func createCompaundPredicate(date: Date, currency: Currency) -> NSCompoundPredicate {
        let datePredicate = NSPredicate(format: "%K == %D", #keyPath(CDHistoricalBulletin.date), date as CVarArg)
        let numberPredicate = NSPredicate(format: "%K == %D", #keyPath(CDHistoricalRate.currencyNumber), currency.number)
        let compaundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, numberPredicate])
        return compaundPredicate
    }
}
