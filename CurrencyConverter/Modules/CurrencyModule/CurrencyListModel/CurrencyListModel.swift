//
//  CurrencyListModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

final class CurrencyListModel {
    static let shared = CurrencyListModel()
    
    lazy var containerName = String()
    private let groupManager = GroupManager()
    private let currencyManager = CurrencyManager()
    private let containerManager = ContainerManager()
    private lazy var currencyDataSource = CurrencyListDataSource.shared
    
    func fillCurrencyDataSource() {
        guard
            let exceptCurrencies = containerManager.currencies(from: containerName),
            let currencies = currencyManager.getCurrencyExcept(currencies: exceptCurrencies) else {
            return
        }
        currencyDataSource.currencyList = currencies
        currencyDataSource.groups = fillDataSourceGroups()
    }
    
    private func fillDataSourceGroups() -> [Group] {
        let currencies = currencyDataSource.currencyList
        var keys: Set<Int> = []
        currencies.forEach { currency in
            keys.update(with: currency.groupKey)
        }
        let groupKeys = Array(keys)
        guard let groups = groupManager.fetchGroups(by: groupKeys) else { return [] }
        return groups
    }
    
    func filterCurrency(text: String) {
        guard !text.isEmpty else {
            currencyDataSource.filteredCurrency = []
            return
        }
            let whitespaceCharacterSet = CharacterSet.whitespaces
            let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()

            let filtered = currencyDataSource.currencyList.filter {
                $0.code.lowercased().contains(text) ||
                $0.currency.lowercased().contains(text)
            }
            if !filtered.isEmpty {
                currencyDataSource.filteredCurrency.removeAll()
                currencyDataSource.filteredCurrency = filtered
            } else {
                currencyDataSource.filteredCurrency = []
            }
    }
    
    func selectedCurrency(at indexPath: IndexPath) -> Currency {
        let groupsCurrencies = currencyDataSource.currencyList
        let groups = currencyDataSource.groups
        let currencies = groupsCurrencies.filter { $0.groupKey == groups[indexPath.section].key }
        return  currencies[indexPath.row]
    }
    
    func selectedFilteredCurrency(at indexPath: IndexPath) -> Currency {
        let currency = currencyDataSource.filteredCurrency[indexPath.row]
        return currency
    }
}
