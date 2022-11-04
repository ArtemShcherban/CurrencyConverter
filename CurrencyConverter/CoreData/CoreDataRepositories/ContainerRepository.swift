//
//  ContainerRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//

import Foundation
import CoreData

protocol ContainerDataRepository {
    var countOfContainers: Int { get }
    func createContainers()
    func currencyCodes(from container: String) -> [String]?
    func update(container: String, with currency: Currency)
    func replaceIn(container: String, at row: Int, with currency: Currency)
    func removeFrom(container: String, currency: Currency)
}

class ContainerRepository: Repository, ContainerDataRepository {
    var countOfContainers: Int {
        let count = coreDataStack.fetchManagedObjectCount(managedObject: CDContainer.self)
        return count
    }
    
    func createContainers() {
        coreDataStack.backgroundContext.performAndWait {
            let rateContainer = CDRateContainer(context: coreDataStack.backgroundContext)
            rateContainer.currencyCodes = []
            let converterContainer = CDConverterContainer(context: coreDataStack.backgroundContext)
            converterContainer.currencyCodes = []
            coreDataStack.synchronizeContexts()
        }
    }
    
    func currencyCodes(from container: String) -> [String]? {
        guard
            let objectID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: objectID) as? CDContainer else {
            return nil
        }
        return cdContainer.currencyCodes
    }
    
    func update(container: String, with currency: Currency) {
        guard
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer else {
            print("Failed to update with currency: \(currency)")
            return
        }
        cdContainer.currencyCodes.append(currency.code)
        coreDataStack.saveContext()
    }
    
    func replaceIn(container: String, at row: Int, with currency: Currency) {
        guard
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer else {
            print("Failed to replace with new currency: \(currency)")
            return
        }
        cdContainer.currencyCodes.remove(at: row)
        cdContainer.currencyCodes.insert(currency.code, at: row)
        coreDataStack.saveContext()
    }
    
    func removeFrom(container: String, currency: Currency) {
        guard
            let cdContainerID = getCDContainerID(for: container),
            let cdContainer = coreDataStack.managedContext.object(with: cdContainerID) as? CDContainer else {
            print("Failed to remove currency: \(currency)")
            return
        }
        cdContainer.currencyCodes = cdContainer.currencyCodes.filter { code in
            code != currency.code
        }
        coreDataStack.saveContext()
    }
    
    private func getCDContainerID(for containerName: String) -> NSManagedObjectID? {
        var objectID: NSManagedObjectID?
        
        switch containerName {
        case ContainerName.exRates:
            if let result = coreDataStack.fetchManagedObject(managedObject: CDRateContainer.self) {
                objectID = result.first?.objectID
            }
            
        case ContainerName.converter:
            if let result = coreDataStack.fetchManagedObject(managedObject: CDConverterContainer.self) {
                objectID = result.first?.objectID
            }
        default:
            return objectID
        }
        return objectID
    }
}
