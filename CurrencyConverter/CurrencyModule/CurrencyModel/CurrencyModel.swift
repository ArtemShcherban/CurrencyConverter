//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class CurrencyModel {
    private lazy var dataSource = CurrencyDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    
    func fillCurrencyDataSource() {
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        let codeSortDescription = NSSortDescriptor(key: #keyPath(Currency.code), ascending: true)
        fetchRequest.sortDescriptors = [codeSortDescription]
        guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else { return }
        dataSource.currencyList = result
    }
    
    func filterCurrency(text: String) {
        if !text.isEmpty {
            let whitespaceCharacterSet = CharacterSet.whitespaces
            let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
            
            let filtered = dataSource.currencyList.filter {
                $0.selected == false
            }
                .filter {
                    $0.code.lowercased().contains(text) ||
                    $0.currency.lowercased().contains(text)
                }
            if !filtered.isEmpty {
                dataSource.filteredCurrency.removeAll()
                dataSource.filteredCurrency = filtered
            } else {
                dataSource.filteredCurrency = []
            }
        } else {
            dataSource.filteredCurrency = []
        }
    }
    
    func selectCurrency(for indexPath: IndexPath) -> Currency {
        let currencies = dataSource.currencyList
            .filter { $0.groupKey == dataSource.groups.filter { $0.visible == true }[indexPath.section].key }
            .filter { $0.selected == false }
        currencies.count == 1 ? dataSource.groups.filter { $0.visible == true }[indexPath.section].visible = false : nil
        let currency = currencies[indexPath.row]
        currency.selected = true
        return currency
    }
    
    func selectFilteredCurrency(for indexPath: IndexPath) -> Currency {
        let currency = dataSource.filteredCurrency[indexPath.row]
        currency.selected = true
        return currency
    }
}
