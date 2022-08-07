//
//  CurrencyDisplayedModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import Foundation
import CoreData

final class CurrencyDisplayedModel {
    private lazy var dataSource = RatesDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    
    func fillRatesDataSource() {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        let predicate = NSPredicate(format: "%K == true", #keyPath(Currency.selected))
        let sequenceIdSortDescriptor = NSSortDescriptor(key: #keyPath(Currency.sequenceId), ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sequenceIdSortDescriptor]
        
        guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else { return }
        dataSource.currenciesDisplayed = result
    }
    
    func insert(currency: Currency) {
        let countDisplayed = dataSource.currenciesDisplayed.count
        currency.sequenceId = Int16(countDisplayed)
        dataSource.currenciesDisplayed.insert(currency, at: countDisplayed)
        coreDataStack.saveContext()
    }
    
    func changeCurrency(at indexPathRow: Int, currency: Currency) {
        let previousCurrency = dataSource.currenciesDisplayed[indexPathRow]
        previousCurrency.selected = false
        previousCurrency.sequenceId = 0
        currency.buy = 0.0
        currency.sell = 0.0
        currency.sequenceId = Int16(indexPathRow)
        dataSource.currenciesDisplayed.remove(at: indexPathRow)
        dataSource.currenciesDisplayed.insert(currency, at: indexPathRow)
        coreDataStack.saveContext()
    }
    
    func removeCurrency(at indexPath: IndexPath) {
        let currency = dataSource.currenciesDisplayed[indexPath.row]
        currency.selected = false
        currency.sequenceId = 0
        currency.buy = 0.0
        currency.sell = 0.0
        dataSource.currenciesDisplayed.remove(at: indexPath.row)
        for each in dataSource.currenciesDisplayed where each.sequenceId < indexPath.row {
            each.sequenceId -= 1
        }
        coreDataStack.saveContext()
    }
}
