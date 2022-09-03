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
    func getSpecified(by numbers: [Int16]) -> [Currency]?
    func getAllExcept(currencies: [Currency]) -> [Currency]?
    func get(byCurrency number: Int16) -> Currency?
    func updateCurrencyRate(currency: Currency)
    func updateCurrencyGroup(byCurrency numbers: [Int16], with groupKey: Int16)
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
        cdCurrency.country = currency.country
        cdCurrency.currencyPlural = currency.currencyPlural
        cdCurrency.groupKey = currency.groupKey
        cdCurrency.container = currency.container
        coreDataStack.saveContext()
    }
    
    func getSpecified(by numbers: [Int16]) -> [Currency]? {
        let predicates = compaundPredicate(including: true, currencyNumbers: numbers)
        let fetchRequest = createFetchRequest(compaundPredicates: predicates)
        return getCurrencies(from: fetchRequest)
    }
    
    func get(byCurrency number: Int16) -> Currency? {
        let predicates = compaundPredicate(including: true, currencyNumbers: [number])
        let fetchRequest = createFetchRequest(compaundPredicates: predicates)
        guard let currency = getCurrencies(from: fetchRequest)?.first else { return nil }
        return currency
    }
    
    func get(byCurrency code: String) -> Currency? {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDCurrency.code), code)
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        fetchRequest.predicate = predicate
        guard let currency = getCurrencies(from: fetchRequest)?.first else { return nil }
        return currency
    }
    
    func getAllExcept(currencies: [Currency]) -> [Currency]? {
        var currencyNumbers: [Int16] = []
        currencies.forEach { currencyNumbers.append($0.number) }
        let predicates = compaundPredicate(including: false, currencyNumbers: currencyNumbers)
        let fetchRequest = createFetchRequest(compaundPredicates: predicates)
        return getCurrencies(from: fetchRequest)
    }
    
    func updateCurrencyRate(currency: Currency) {
        guard let cdCurrency = getCDCurrencies(by: [currency.number])?.first else {
            print("Failed to update \(currency)")
            return
        }
        cdCurrency.buy = currency.buy
        cdCurrency.sell = currency.sell
        coreDataStack.saveContext()
    }
    
    func updateCurrencyGroup(byCurrency numbers: [Int16], with groupKey: Int16) {
        guard let cdCurrencies = getCDCurrencies(by: numbers) else {
            print("Failed to update currencies with groupKey \(groupKey)")
            return
        }
        cdCurrencies.forEach { $0.groupKey = groupKey }
        coreDataStack.saveContext()
    }
    
    private func getCDCurrencies(by numbers: [Int16]) -> [CDCurrency]? {
        let predicate = compaundPredicate(including: true, currencyNumbers: numbers)
        let fetchRequest = createFetchRequest(compaundPredicates: predicate)
        do {
            let cdCurrency = try coreDataStack.managedContext.fetch(fetchRequest)
            return cdCurrency
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
    
    private func compaundPredicate(including: Bool, currencyNumbers: [Int16]) -> NSCompoundPredicate {
        let format = including ? "%K == %D" : "%K != %D"
        var predicates: [NSPredicate] = []
        currencyNumbers.forEach { number in
            let predicate = NSPredicate(format: format, #keyPath(CDCurrency.number), number)
            predicates.append(predicate)
        }
        switch including {
        case true:
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        default:
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    private func createFetchRequest(compaundPredicates: NSCompoundPredicate) -> NSFetchRequest<CDCurrency> {
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        let compaundPredicate = compaundPredicates
        let codeSortDescriptor = NSSortDescriptor(key: #keyPath(CDCurrency.code), ascending: true)
        fetchRequest.predicate = compaundPredicate
        fetchRequest.sortDescriptors = [codeSortDescriptor]
        return fetchRequest
    }
    
    private func getCurrencies(from fetchRequest: NSFetchRequest<CDCurrency>) -> [Currency]? {
        var currencies: [Currency] = []
        do {
            let cdCurrencies = try coreDataStack.managedContext.fetch(fetchRequest)
            cdCurrencies.forEach { currencies.append($0.convertToCurrency()) }
            return currencies
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
}
