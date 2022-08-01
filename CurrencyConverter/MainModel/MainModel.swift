//
//  MainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.08.2022.
//

import UIKit
import CoreData

class MainModel {
    private lazy var coreDataStack = CoreDataStack.shared
    
    func insertWorldCurrencies() {
        let fetch: NSFetchRequest<Currency> = Currency.fetchRequest()
        fetch.predicate = NSPredicate(format: "currency != nil")
        
        let currenciesCount = (try? coreDataStack.managedContext.count(for: fetch)) ?? 0
        
        if currenciesCount > 0 {
            return
        }
        
        guard let path = Bundle.main.path(forResource: "WorldCurrencies", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else { return }
        
        for dictionary in dataArray {
            let currency = Currency(context: coreDataStack.managedContext)
            if let dict = dictionary as? [String: Any] {
                currency.country = dict["Country"] as? String
                currency.currency = dict["Currency"] as? String
                currency.code = dict["Code"] as? String
                if let number = dict["Number"] as? NSNumber {
                    currency.number = number.int16Value
                }
            }
        }
        coreDataStack.saveContext()
    }
    
    func insertCurrenciesGroup() {
        let fetch: NSFetchRequest<CurrencyGroup> = CurrencyGroup.fetchRequest()
        fetch.predicate = NSPredicate(format: "name != nil" )
        
        let currenciesGroupCount = (try? coreDataStack.managedContext.count(for: fetch)) ?? 0
        
        if currenciesGroupCount > 0 {
            return
        }
        
        let fetchCurrency: NSFetchRequest<Currency> = Currency.fetchRequest()
        guard let currencies = try? coreDataStack.managedContext.fetch(fetchCurrency) else { return }

        for currency in currencies {
            guard let firstCharacter = currency.code?.first else { return }
            let groupTitle = String(firstCharacter)
            let fetchByName: NSFetchRequest<CurrencyGroup> = CurrencyGroup.fetchRequest()
            fetchByName.predicate = NSPredicate(format: "%K == %@", #keyPath(CurrencyGroup.name), groupTitle)
            
            guard let result = try? coreDataStack.managedContext.fetch(fetchByName) else { return }
           
            if result.isEmpty {
                let group = CurrencyGroup(context: coreDataStack.managedContext)
                group.name = groupTitle
                group.addToCurrencies(currency)
                coreDataStack.saveContext()
            } else {
                guard let group = result.first else { return }
                group.addToCurrencies(currency)
                coreDataStack.saveContext()
            }
        }
    }
}
