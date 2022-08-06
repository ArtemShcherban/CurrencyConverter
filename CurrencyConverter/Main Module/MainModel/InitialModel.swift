//
//  InitialModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//

import Foundation
import CoreData

final class InitialModel {
    private lazy var coreDataStack = CoreDataStack.shared
    
    func insertCurrencies() {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        let resultCount = (try? coreDataStack.managedContext.count(for: fetchRequest)) ?? 0
        
        if resultCount > 0 {
            return
        }
        
        guard
            let path = Bundle.main.path(forResource: "WorldCurrencies", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            return
        }
        
        for dictionary in dataArray {
            if let dict = dictionary as? [String: Any] {
                let currency = Currency(context: coreDataStack.managedContext)
                currency.currency = dict["Currency"] as? String ?? String()
                currency.code = dict["Code"] as? String ?? String()
                currency.country = dict["Country"] as? String ?? String()
                currency.selected = false
                if let number = dict["Number"] as? NSNumber {
                    currency.number = number.int16Value
                }
            }
        }
        coreDataStack.saveContext()
    }
    
    func insertGroups() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        guard let resultCount = try? coreDataStack.managedContext.count(for: fetchRequest) else { return }
        
        if resultCount > 0 {
            return
        }
        createPopularGroup()
        
        let currencyFetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        let compoundPredicate = compoundPredicate(with: AppConstants.popularCurrencies, reverse: true)
        let codeSortDescriptor = NSSortDescriptor(key: #keyPath(Currency.code), ascending: true)
        currencyFetchRequest.sortDescriptors = [codeSortDescriptor]
        currencyFetchRequest.predicate = compoundPredicate
        
        var groupKey = 1
        guard let currencies = try? coreDataStack.managedContext.fetch(currencyFetchRequest) else { return }
        for currency in currencies {
            let groupName = String(currency.code.first ?? " ")
            let groupRequest: NSFetchRequest<Group> = Group.fetchRequest()
            groupRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Group.name), groupName)
            
            guard let groups = try? coreDataStack.managedContext.fetch(groupRequest) else { return }
            if groups.isEmpty {
                let group = Group(context: coreDataStack.managedContext)
                group.name = groupName
                group.key = Int16(groupKey)
                group.visible = true
                currency.groupKey = group.key
                groupKey += 1
            } else {
                guard let group = groups.first else { return }
                currency.groupKey = group.key
            }
        }
        coreDataStack.saveContext()
    }
    
    private func createPopularGroup() {
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.predicate = compoundPredicate(with: AppConstants.popularCurrencies)
        
        guard let currencies = try? coreDataStack.managedContext.fetch(request) else { return }
        
        let popularGroup = Group(context: coreDataStack.managedContext)
        popularGroup.name = "Popular"
        popularGroup.key = Int16(0)
        popularGroup.visible = true
        for currency in currencies {
            currency.groupKey = popularGroup.key
        }
        coreDataStack.saveContext()
    }
    
    private func compoundPredicate(with codes: [String], reverse: Bool = false ) -> NSCompoundPredicate {
        let format = reverse ? "%K != %@" : "%K == %@"
        
        var predicates: [NSPredicate] = []
        for code in codes {
            let predicate = NSPredicate(format: format, #keyPath(Currency.code), code)
            predicates.append(predicate)
        }
        
        if reverse {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        } else {
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}
