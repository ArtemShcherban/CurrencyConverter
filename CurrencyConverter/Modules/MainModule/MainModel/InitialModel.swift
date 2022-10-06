//
//  InitialModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//

import Foundation

final class InitialModel {
    private let groupManager = GroupManager()
    private let currencyManager = CurrencyManager()
    private let containerRepository = ContainerDataRepository()
//    private let containerManager = ContainerManager()
    
    func insertCurrencies(complition: @escaping () -> Void) {
        let currencyCount = currencyManager.getCurrencyCount()
        if currencyCount > 0 {
            complition()
            return
        }
        guard
            let path = Bundle.main.path(forResource: "WorldCurrencies", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            return
        }
        
        DispatchQueue.global().async {
            for dictionary in dataArray {
                if let dictionary = dictionary as? [String: Any] {
                    let currency = Currency(from: dictionary)
                    self.currencyManager.createCurrency(currency)
                }
            }
            complition()
        }
    }
    
    func insertGroups() {
        let groupCount = groupManager.fetchGroupCount()
        if groupCount > 0 { return }
        
        var popularCurrencies: [Currency] = []
        DefaultConstants.popularCurrencyCodes.forEach {
            if let currency = currencyManager.getCurrency(by: $0) {
                popularCurrencies.append(currency)
            }
        }
        
        createPopularGroup(currencyNumbers: DefaultConstants.popularCurrencyCodes)
        
        var groupKey: Int16 = 0
        guard let currencies = currencyManager.getCurrencyExcept(currencies: popularCurrencies) else { return }
        for currency in currencies {
            let groupName = String(currency.code.first ?? " ")
            if
                let groups = groupManager.fetchGroup(by: [groupName]),
                let group = groups.first {
                currencyManager.setGroupKeyForCurrency(with: currency.number, with: group.key)
            } else {
                groupKey += 1
                let group = Group(
                    visible: true,
                    name: groupName,
                    key: Int(groupKey)
                )
                groupManager.createGroup(group)
                currencyManager.setGroupKeyForCurrency(with: currency.number, with: group.key)
            }
        }
    }
    
    private func createPopularGroup(currencyNumbers: [Int]) {
        let group = Group(visible: true, name: TitleConstants.popular, key: 0)
        groupManager.createGroup(group)
        currencyNumbers.forEach { currencyNumber in
            currencyManager.setGroupKeyForCurrency(with: currencyNumber, with: group.key)
        }
    }
    
    func createContainers() {
        let countOfContainers = containerRepository.countOfContainers
        if countOfContainers > 0 {
            return
        }
        containerRepository.createContainers()
        updateContainersWithDefaultCurrencies()
    }
    
    private func updateContainersWithDefaultCurrencies() {
        updateRatesContainer()
        updateConverterContainer()
    }
    
    private func updateRatesContainer() {
        let containerName = ContainerConstants.Name.rate
        let currencyNumbers = DefaultConstants.currenciesCodes.sorted()
        currencyNumbers.forEach { currencyNumber in
            guard let currency = currencyManager.getCurrency(by: currencyNumber) else { return }
            containerRepository.fillIn(container: containerName, with: currency)
        }
    }
    
    private func updateConverterContainer() {
        let containerName = ContainerConstants.Name.converter
        let currencyNumbers = DefaultConstants.currenciesCodes
        guard let currency = currencyManager.getCurrency(by: DefaultConstants.baseCurrencyCode) else {
            return
        }
        containerRepository.fillIn(container: containerName, with: currency)
        for currencyNumber in currencyNumbers.sorted() where currencyNumber != 985 {
            guard let currency = currencyManager.getCurrency(by: currencyNumber) else { return }
            containerRepository.fillIn(container: containerName, with: currency)
        }
    }
}
