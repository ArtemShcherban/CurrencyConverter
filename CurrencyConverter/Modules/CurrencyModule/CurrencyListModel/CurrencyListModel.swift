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
    private let groupRepository = GroupRepository()
    private let currencyRepository = CurrencyRepository()
    private let containerRepository = ContainerRepository()
    private(set) lazy var currencyDataSource = CurrencyListDataSource()
    
    func fillCurrencyDataSource() {
        guard
            let presentCurrencies = containerRepository.currencies(from: containerName),
            let currencies = currencyRepository.allCurrencies(except: presentCurrencies ) else {
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
        guard let groups = groupRepository.group(by: groupKeys) else { return [] }
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
    
    func groupTitle(for section: Int, in tableView: CurrencyListTableView) -> String {
        if tableView.isFiltered {
            let title = !currencyDataSource.filteredCurrency.isEmpty ?
            TitleConstants.searchResult : TitleConstants.noCurrencyFound
            return title
        }
        let title = currencyDataSource.groups
            .filter { $0.visible == true }[section].name
        return title
    }
}
