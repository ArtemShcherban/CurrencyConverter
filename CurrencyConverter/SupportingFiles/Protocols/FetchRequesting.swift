//
//  Requesting.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//

import Foundation
import CoreData

protocol FetchRequesting: AnyObject {
}

extension FetchRequesting {
    func performRequest(for tableView: String) -> [CDCurrencyContainer] {
        let coreDataStack = CoreDataStack.shared
        switch tableView {
        case ContainerConstants.Name.rate:
            let fetchRequest: NSFetchRequest<RateCurrencyContainer> = RateCurrencyContainer.fetchRequest()
            guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else { return [] }
            return result
        case ContainerConstants.Name.converter:
            let fetchRequest: NSFetchRequest<ConverterCurrencyContainer> = ConverterCurrencyContainer.fetchRequest()
            guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else { return [] }
            return result
        default:
            return []
        }
    }
}
