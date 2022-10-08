//
//  CurrencyListModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

protocol CurrencyListModelDelegate: AnyObject { }

final class CurrencyListModel {
    lazy var containerName = delegate?.ratesModel?.containerName ?? String()
    private let groupRepository = GroupRepository()
    private let currencyRepository = CurrencyRepository()
    private let containerRepository = ContainerRepository()
    
    weak var delegate: CurrencyListViewController?
    
    func fillCurrencyDataSource() {
        guard
            let presentCurrencies = containerRepository.currencies(from: containerName),
            let currencies = currencyRepository.allCurrencies(except: presentCurrencies ) else {
            return
        }
        delegate?.currencyList = currencies
        delegate?.groups = fillDataSourceGroups()
    }
    
    private func fillDataSourceGroups() -> [Group] {
        let currencies = delegate?.currencyList
        var keys: Set<Int> = []
        currencies?.forEach { currency in
            keys.update(with: currency.groupKey)
        }
        let groupKeys = Array(keys)
        guard let groups = groupRepository.group(by: groupKeys) else { return [] }
        return groups
    }
    
    func filterCurrency(text: String) {
        guard !text.isEmpty else {
            delegate?.filteredCurrency = []
            return
        }
            let whitespaceCharacterSet = CharacterSet.whitespaces
            let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()

        guard let delegate = delegate else { return }

            let filtered = delegate.currencyList.filter {
                $0.code.lowercased().contains(text) ||
                $0.currency.lowercased().contains(text)
            }
            if !filtered.isEmpty {
                delegate.filteredCurrency.removeAll()
                delegate.filteredCurrency = filtered
            } else {
                delegate.filteredCurrency = []
            }
    }
    
    func selectedCurrency(at indexPath: IndexPath) -> Currency? {
        let groupsCurrencies = delegate?.currencyList
        let groups = delegate?.groups
        let currencies = groupsCurrencies?.filter { $0.groupKey == groups?[indexPath.section].key }
        return  currencies?[indexPath.row]
    }
    
    func selectedFilteredCurrency(at indexPath: IndexPath) -> Currency? {
        let currency = delegate?.filteredCurrency[indexPath.row]
        return currency
    }
    
    func groupTitle(for section: Int, in tableView: CurrencyListTableView) -> String {
        guard let delegate = delegate else {
            return String()
        }
        
        if tableView.isFiltered {
            let title = !delegate.filteredCurrency.isEmpty ?
            TitleConstants.searchResult : TitleConstants.noCurrencyFound
            return title
        }
        let title = delegate.groups
            .filter { $0.visible == true }[section].name
        return title
    }
}
