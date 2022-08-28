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
//    func get(for tableViewName: String) -> CurrencyContainer?
}

struct CurrencyContainerDataRepository: CurrencyContainerRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func getCount() -> Int {
        let containerCount = coreDataStack.fetchManagedObjectCount(managedObgect: CDCurrencyContainer.self)
        return containerCount
    }
    
    func createCurrenciesContainers() {
        _ = RateCurrencyContainer(context: coreDataStack.managedContext)
        _ = ConverterCurrencyContainer(context: coreDataStack.managedContext)
        coreDataStack.saveContext()
    }
    
    func update(container: String, with currency: Currency) {
        guard
            let container = getCDCurrencyContainer(name: container),
            let cdCurrency = getCDCurrency(by: currency.number) else {
            print("Container: failed to update")
            return
        }
        container.addToCurrencies(cdCurrency)
        coreDataStack.saveContext()
    }
    
//    func get(for tableViewName: String) -> CurrencyContainer? {
//        guard let cdCurrencyContainer = getCDCurrencyContainer(name: tableViewName) else { return nil }
//        return cdCurrencyContainer.convertToCurrencyContainer()
//    }
    
    private func getCDCurrencyContainer(name: String) -> CDCurrencyContainer? {
        switch name {
        case TableViewCostants.Name.rate:
            guard
                let result = coreDataStack.fetchManagedObject(managedObject: RateCurrencyContainer.self),
                let container = result.first else {
                return nil
            }
            return container
        case TableViewCostants.Name.converter:
            guard
                let result = coreDataStack.fetchManagedObject(managedObject: ConverterCurrencyContainer.self),
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
