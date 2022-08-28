//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

protocol CurrencyListModelDelegate: AnyObject {
    func currencyListTableViewReloadData()
}

class CurrencyListModel: FetchRequesting {
    static let shared = CurrencyListModel()
    
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var currencyDataSource = CurrencyDataSource.shared
    
    private let currencyManager = CurrencyManager()
    
    lazy var tableView = String()
    
    weak var delegate: CurrencyListModelDelegate?
    
    func fillDataSourceCurrencies() {
//        var predicates: [NSPredicate] = []
//
//        let result = performRequest(for: tableView)
//
//        if !result.isEmpty {
//            guard
//                let container = result.first,
//                let currencies = container.currencies?.array as? [CurrencyOLD] else {
//                return
//            }
//            predicates = createPredicate(from: currencies)
//        }
//        
//        let currencyRequest: NSFetchRequest<CurrencyOLD> = CurrencyOLD.fetchRequest()
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//        let codeSortDescriptor = NSSortDescriptor(key: #keyPath(CurrencyOLD.code), ascending: true)
//        currencyRequest.predicate = compoundPredicate
//        currencyRequest.sortDescriptors = [codeSortDescriptor]
        
        guard let currencies = currencyManager.fetchCurrencyExcept(currencies: []) else { return }
        currencyDataSource.currencyList = currencies
    }
    
//    func fillDataSourceCurrencies() {
//        var predicates: [NSPredicate] = []
//
//        let result = performRequest(for: tableView)
//
//        if !result.isEmpty {
//            guard
//                let container = result.first,
//                let currencies = container.currencies?.array as? [CurrencyOLD] else {
//                return
//            }
//            predicates = createPredicate(from: currencies)
//        }
//
//        let currencyRequest: NSFetchRequest<CurrencyOLD> = CurrencyOLD.fetchRequest()
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
//        let codeSortDescriptor = NSSortDescriptor(key: #keyPath(CurrencyOLD.code), ascending: true)
//        currencyRequest.predicate = compoundPredicate
//        currencyRequest.sortDescriptors = [codeSortDescriptor]
//
//        guard let currencies = try? coreDataStack.managedContext.fetch(currencyRequest) else { return }
//        currencyDataSource.currencyList = currencies
//    }
    
    func fillDataSourceGroups() {
        let groupsCurrencies = currencyDataSource.currencyList
        var groupsKeys: Set<Int> = []
        groupsCurrencies.forEach { currency in
            groupsKeys.update(with: Int(currency.groupKey))
        }
        
        var predicates: [NSPredicate] = []
        
        for each in groupsKeys {
            let predicate = NSPredicate(format: "%K == %D", #keyPath(Group.key), each)
            predicates.append(predicate)
        }
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let keySortDescriptor = NSSortDescriptor(key: #keyPath(Group.key), ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [keySortDescriptor]
        
        guard let groups = try? coreDataStack.managedContext.fetch(fetchRequest) else { return }
        currencyDataSource.groups = groups
    }
    
    private func createPredicate(from currencies: [CurrencyOLD]) -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        for currency in currencies {
            let predicate = NSPredicate(format: "%K != %@", #keyPath(CurrencyOLD.code), currency.code)
            predicates.append(predicate)
        }
        return predicates
    }
    
    func filterCurrency(text: String) {
//        if !text.isEmpty {
//            let whitespaceCharacterSet = CharacterSet.whitespaces
//            let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
//
//            let filtered = currencyDataSource.currencyList.filter {
//                $0.code.lowercased().contains(text) ||
//                $0.currency.lowercased().contains(text)
//            }
//            if !filtered.isEmpty {
//                currencyDataSource.filteredCurrency.removeAll()
//                currencyDataSource.filteredCurrency = filtered
//            } else {
//                currencyDataSource.filteredCurrency = []
//            }
//        } else {
//            currencyDataSource.filteredCurrency = []
//        }
    }
    
    func selectedCurrency(at indexPath: IndexPath) -> Currency {
        let groupsCurrencies = currencyDataSource.currencyList
        let groups = currencyDataSource.groups
        let currencies = groupsCurrencies.filter { $0.groupKey == groups[indexPath.section].key }
        return  currencies[indexPath.row]
    }
    
//    func selectedCurrency(at indexPath: IndexPath) -> CurrencyOLD {
//        let groupsCurrencies = currencyDataSource.currencyList
//        let groups = currencyDataSource.groups
//        let currencies = groupsCurrencies.filter { $0.groupKey == groups[indexPath.section].key }
//        return  currencies[indexPath.row]
//    }
    
//    func selectedFilteredCurrency(at indexPath: IndexPath) -> CurrencyOLD {
//        let currency = currencyDataSource.filteredCurrency[indexPath.row]
//        return currency
//    }
}
