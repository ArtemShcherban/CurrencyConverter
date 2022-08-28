//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation
import CoreData

protocol CurrencyRepository {
    func getCount() -> Int
    func create(currency: Currency)
    func getAll() -> [Currency]?
    func getAllExcept(currencies: [Currency]) -> [Currency]?
    func get(byCurrency number: Int16) -> Currency?
    func update(currency: Currency)
    func delete(byCurrency number: Int16)
}

struct CurrencyDataRepository: CurrencyRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func getCount() -> Int {
        let currencyCount = coreDataStack.fetchManagedObjectCount(managedObgect: CDCurrency.self)
        return currencyCount
    }
    
    func create(currency: Currency) {
        let cdCurrency = CDCurrency(context: coreDataStack.managedContext)
        cdCurrency.currency = currency.currency
        cdCurrency.number = currency.number
        cdCurrency.sell = currency.sell
        cdCurrency.buy = currency.buy
        cdCurrency.code = currency.code
        cdCurrency.country = cdCurrency.country
        cdCurrency.currencyPlural = cdCurrency.currencyPlural
        cdCurrency.groupKey = cdCurrency.groupKey
        cdCurrency.container = cdCurrency.container
        coreDataStack.saveContext()
    }
    
    func getAll() -> [Currency]? {
        return nil
    }
    
    func get(byCurrency number: Int16) -> Currency? {
        return nil
    }
    
    func getAllExcept(currencies: [Currency]) -> [Currency]? {
        var currencies: [Currency] = []
        guard let cdCurrencies = getAllCDCurrenciesExcept(currencies) else { return nil }
        
        cdCurrencies.forEach { cdCurrency in
            currencies.append(cdCurrency.convertToCurrency())
        }
        return currencies
    }
    
    func update(currency: Currency) {
    }
    
    func delete(byCurrency number: Int16) {
    }
    
    private func getAllCDCurrenciesExcept(_ currencies: [Currency]) -> [CDCurrency]? {
        let predicates = createPredicate(from: currencies)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        let codeSortDescriptor = NSSortDescriptor(key: #keyPath(CDCurrency.code), ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [codeSortDescriptor]
        
        do {
            let result = try coreDataStack.managedContext.fetch(fetchRequest)
            return result
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
    
    private func createPredicate(from currencies: [Currency]) -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        for currency in currencies {
            let predicate = NSPredicate(format: "%K != %@", #keyPath(CDCurrency.code), currency.code)
            predicates.append(predicate)
        }
        return predicates
    }
}
