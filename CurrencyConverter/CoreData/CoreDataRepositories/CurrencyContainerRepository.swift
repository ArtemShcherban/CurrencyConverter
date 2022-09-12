//
//  CurrencyContainerRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//

import Foundation
import CoreData

protocol CurrencyContainerRepository {
    func getCount() -> Int
    func createCurrenciesContainers()
    func getCurrencyCount(inContainer name: String) -> Int
    func getFromContainer(name: String) -> [Currency]?
    func update(container: String, with currency: Currency)
    func replace(inContainer name: String, at row: Int, with currency: Currency)
    func delete(currency: Currency, fromContainer name: String)
}

struct CurrencyContainerDataRepository: CurrencyContainerRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func getCount() -> Int {
        let containerCount = coreDataStack.fetchManagedObjectCount(managedObject: CDContainer.self)
        return containerCount
    }
    
    func createCurrenciesContainers() {
        _ = CDRateContainer(context: coreDataStack.managedContext)
        _ = CDConverterContainer(context: coreDataStack.managedContext)
        coreDataStack.saveContext()
    }
    
    func getCurrencyCount(inContainer name: String) -> Int {
        let cdCurrencyContainer = getCDCurrencyContainer(name: name)
        let currenciesCount = cdCurrencyContainer?.currencies?.count
        return currenciesCount ?? 0
    }
    
    func getFromContainer(name: String) -> [Currency]? {
        var currencies: [Currency] = []
        guard
            let cdContainer = getCDCurrencyContainer(name: name),
            let cdCurrencies = cdContainer.currencies?.array as? [CDCurrency]  else {
            return nil
        }
        cdCurrencies.forEach { cdCurrency in
            currencies.append(cdCurrency.convertToCurrency())
        }
        return currencies
    }
    
    func update(container: String, with currency: Currency) {
        guard
            let container = getCDCurrencyContainer(name: container),
            let cdCurrency = getCDCurrency(by: currency.number) else {
            print("Failed to update container with \(currency)")
            return
        }
        container.addToCurrencies(cdCurrency)
        coreDataStack.saveContext()
    }
    
    func replace(inContainer name: String, at row: Int, with currency: Currency) {
        guard
            let cdCurrency = getCDCurrency(by: currency.number),
            let cdCurrencyContainer = getCDCurrencyContainer(name: name) else {
            print("Failed to replace with new currency: \(currency)")
            return
        }
        cdCurrencyContainer.replaceCurrencies(at: row, with: cdCurrency)
        coreDataStack.saveContext()
    }
    
    func delete(currency: Currency, fromContainer name: String) {
        guard
            let cdCurrencyContainer = getCDCurrencyContainer(name: name),
            let cdCurrency = getCDCurrency(by: currency.number) else {
            print("Failed to delete currency: \(currency)")
            return
        }
        cdCurrencyContainer.removeFromCurrencies(cdCurrency)
        coreDataStack.saveContext()
    }
    
    private func getCDCurrencyContainer(name: String) -> CDContainer? {
        switch name {
        case ContainerConstants.Name.rate:
            guard
                let result = coreDataStack.fetchManagedObject(managedObject: CDRateContainer.self),
                let container = result.first else {
                return nil
            }
            return container
        case ContainerConstants.Name.converter:
            guard
                let result = coreDataStack.fetchManagedObject(managedObject: CDConverterContainer.self),
                let container = result.first else {
                return nil
            }
            return container
        default:
            return nil
        }
    }
    
    private func getCDCurrency(by number: Int16) -> CDCurrency? {
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDCurrency.number), number)
        fetchRequest.predicate = predicate
        do {
            guard let cdCurrency = try coreDataStack.managedContext.fetch(fetchRequest).first else {
                return nil
            }
            return cdCurrency
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
}
