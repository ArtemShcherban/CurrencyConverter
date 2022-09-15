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
    func get(byCurrency number: Int16) -> Currency?
    func get(byCurrency code: String) -> Currency?
    func getAllExcept(currencies: [Currency]) -> [Currency]?
    func updateRate(for currency: Currency)
    func setGroupKey(forCurrency number: Int16, with key: Int16)
}

struct CurrencyDataRepository: CurrencyRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func create(currency: Currency) {
        coreDataStack.backgroundContext.performAndWait {
            let cdCurrency = CDCurrency(context: coreDataStack.backgroundContext)
            cdCurrency.currency = currency.currency
            cdCurrency.number = currency.number
            cdCurrency.sell = currency.sell
            cdCurrency.buy = currency.buy
            cdCurrency.code = currency.code
            cdCurrency.country = currency.country
            cdCurrency.currencyPlural = currency.currencyPlural
            cdCurrency.groupKey = currency.groupKey
            cdCurrency.container = currency.container
            coreDataStack.saveBackgroundContext()
        }
        coreDataStack.saveContext()
    }
    
    func getCount() -> Int {
        let currencyCount = coreDataStack.fetchManagedObjectCount(managedObject: CDCurrency.self)
        return currencyCount
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
    
    func updateRate(for currency: Currency) {
        guard
            let cdCurrencyID = getCDCurrencyID(for: currency.number),
            let cdCurrency = coreDataStack.managedContext.object(with: cdCurrencyID) as? CDCurrency else {
            print("Failed to update \(currency)")
            return
        }
        cdCurrency.buy = currency.buy
        cdCurrency.sell = currency.sell
        coreDataStack.saveContext()
    }
    
    func setGroupKey(forCurrency number: Int16, with key: Int16) {
        coreDataStack.backgroundContext.perform {
        guard
            let cdCurrencyID = getCDCurrencyID(for: number),
            let cdCurrency = coreDataStack.backgroundContext.object(with: cdCurrencyID) as? CDCurrency else {
            print("Failed to update currencies with group's key: \(key)")
            return
        }
            cdCurrency.groupKey = key
            coreDataStack.saveBackgroundContext()
        }
        coreDataStack.saveContext()
    }
    
    private func getCDCurrencyID(for currencyNumber: Int16) -> NSManagedObjectID? {
        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDCurrency.number), currencyNumber)
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        fetchRequest.predicate = predicate
        var objectID: NSManagedObjectID?
        coreDataStack.managedContext.performAndWait {
            do {
                guard let cdCurrency = try coreDataStack.managedContext.fetch(fetchRequest).first
                else {
                    return
                }
                objectID = cdCurrency.objectID
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return objectID
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
        coreDataStack.backgroundContext.performAndWait {
            do {
                let cdCurrencies = try coreDataStack.backgroundContext.fetch(fetchRequest)
                cdCurrencies.forEach { currencies.append($0.convertToCurrency()) }
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return currencies
    }
}
