//
//  ConverterModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 16.08.2022.
//

import Foundation
import CoreData

class ConverterModel: FetchRequesting {
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    
    func doCalculation(amount: Double) {
        let result = performRequest(for: TableViewCostants.Name.converter)
        guard let container = result.first,
        let currencies = container.currencies?.array as? [Currency] else { return }
        
        guard currencies.count > 1 else { return }
        for currency in currencies[1..<currencies.count] {
            currency.totalAmount = amount / currency.sell
            print(currency)
        }
        coreDataStack.saveContext()
    }
}
