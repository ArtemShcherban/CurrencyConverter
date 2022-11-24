//
//  CurrencyListModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

protocol CurrencyListModelDelegate: AnyObject { }

final class CurrencyListModel {
    lazy var containerName = delegate?.ratesModel?.containerName
    private(set) var containerRepository: ContainerRepository
    
    weak var delegate: CurrencyListViewController?
    
    init(coreDataStack: CoreDataStack) {
        self.containerRepository = ContainerRepository(coreDataStack: coreDataStack)
    }
    
    func currenciesForTableView() {
        guard
            let containerName = containerName,
            let presentCurrencyCodes = containerRepository.currencyCodes(from: containerName),
            let ratesModelDelegate = delegate?.ratesModelDelegate else {
            return
        }
        var currencies = ratesModelDelegate.currenciesList
        presentCurrencyCodes.forEach { code in
            currencies.removeAll {
                $0.code == code
            }
        }
        var currenciesForTableView = currencies
            .filter { $0.groupKey == 0 }
            .sorted { $0.number < $1.number }
        currenciesForTableView.append(contentsOf: currencies
            .filter { $0.groupKey != 0 }
            .sorted { $0.code < $1.code }
        )
        
        delegate?.currenciesInTableView = currenciesForTableView
        delegate?.groups = fillGroups()
    }
    
    private func fillGroups() -> [Group] {
        let currencies = delegate?.currenciesInTableView
        var keys: Set<Int> = []
        currencies?.forEach { currency in
            keys.update(with: currency.groupKey)
        }
        let groupKeys = Array(keys).sorted()
        guard let ratesModelDelegate = delegate?.ratesModelDelegate else { return [] }
        let groups = ratesModelDelegate.groups
        var groupsForTableView: [Group] = []
        groups.forEach { group in
            let tempGroup = group
            if groupKeys.contains(where: { key in
                tempGroup.key == key
            }) {
                groupsForTableView.append(tempGroup)
            }
        }
        return groupsForTableView
    }
    
    func filterCurrency(text: String) {
        guard !text.isEmpty else {
            delegate?.filteredCurrency = []
            return
        }
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let text = text.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
        
        guard let delegate = delegate else { return }
        
        let filtered = delegate.currenciesInTableView.filter {
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
        let groupsCurrencies = delegate?.currenciesInTableView
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
