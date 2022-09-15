//
//  ContainerRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//

import Foundation
import CoreData

protocol ContainerRepository {
    func getCount() -> Int
    func create()
    func getFrom(container: String) -> [Currency]?
    func fillIn(container: String, with currency: Currency)
    func update(container: String, with currency: Currency)
    func replaceIn(container: String, at row: Int, with currency: Currency)
    func removeFrom(container: String, currency: Currency)
}

struct ContainerDataRepository: ContainerRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func getCount() -> Int {
        let containerCount = coreDataStack.fetchManagedObjectCount(managedObject: CDContainer.self)
        return containerCount
    }
    
    func create() {
        coreDataStack.backgroundContext.performAndWait {
            _ = CDRateContainer(context: coreDataStack.backgroundContext)
            _ = CDConverterContainer(context: coreDataStack.backgroundContext)
            coreDataStack.saveBackgroundContext()
        }
        coreDataStack.saveContext()
    }
    
    func getFrom(container: String) -> [Currency]? {
        var currencies: [Currency] = []
        guard
            let objectID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: objectID) as? CDContainer,
            let cdCurrencies = cdContainer.currencies?.array as? [CDCurrency]  else {
            return nil
        }
        cdCurrencies.forEach { cdCurrency in
            currencies.append(cdCurrency.convertToCurrency())
        }
        return currencies
    }
    
    func fillIn(container: String, with currency: Currency) {
        coreDataStack.backgroundContext.performAndWait {
            guard
                let containerObjectID = getCDContainerID(for: container),
                let cdContainer = coreDataStack.backgroundContext.object(with: containerObjectID) as? CDContainer,
                let currencyObjectID = getCDCurrencyID(by: currency.number),
                let cdCurrency = coreDataStack.backgroundContext.object(with: currencyObjectID) as? CDCurrency else {
                    return
                }
            cdContainer.addToCurrencies(cdCurrency)
            coreDataStack.saveBackgroundContext()
        }
        coreDataStack.saveContext()
    }
    
    func update(container: String, with currency: Currency) {
        guard
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer,
            let cdCurrencyID = getCDCurrencyID(by: currency.number),
            let cdCurrency = coreDataStack.managedContext.object(with: cdCurrencyID) as? CDCurrency else {
            print("Failed to update with currency: \(currency)")
            return
        }
        cdContainer.addToCurrencies(cdCurrency)
        coreDataStack.saveContext()
    }
    
    func replaceIn(container: String, at row: Int, with currency: Currency) {
        guard
            let cdCurrencyID = getCDCurrencyID(by: currency.number),
            let cdCurrency = coreDataStack.managedContext.object(with: cdCurrencyID) as? CDCurrency,
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer else {
            print("Failed to replace with new currency: \(currency)")
        return
        }
        cdContainer.replaceCurrencies(at: row, with: cdCurrency)
        coreDataStack.saveContext()
    }
    
    func removeFrom(container: String, currency: Currency) {
        guard
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer,
            let cdCurrencyID = getCDCurrencyID(by: currency.number),
            let cdCurrency = coreDataStack.managedContext.object(with: cdCurrencyID) as? CDCurrency else {
            print("Failed to remove currency: \(currency)")
            return
        }
        cdContainer.removeFromCurrencies(cdCurrency)
        coreDataStack.saveContext()
    }
    
    private func getCDContainerID(for containerName: String) -> NSManagedObjectID? {
        var objectID: NSManagedObjectID?
        
        switch containerName {
        case ContainerConstants.Name.rate:
            if let result = coreDataStack.fetchManagedObject(managedObject: CDRateContainer.self) {
                objectID = result.first?.objectID
            }
            
        case ContainerConstants.Name.converter:
            if let result = coreDataStack.fetchManagedObject(managedObject: CDConverterContainer.self) {
                objectID = result.first?.objectID
            }
        default:
            return objectID
        }
        return objectID
    }
    
    private func getCDCurrencyID(by number: Int16) -> NSManagedObjectID? {
        let fetchRequest: NSFetchRequest<CDCurrency> = CDCurrency.fetchRequest()
        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDCurrency.number), number)
        fetchRequest.predicate = predicate
        var objectID: NSManagedObjectID?
        coreDataStack.managedContext.performAndWait {
            do {
                guard
                    let cdCurrency = try coreDataStack.managedContext.fetch(fetchRequest).first
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
}
