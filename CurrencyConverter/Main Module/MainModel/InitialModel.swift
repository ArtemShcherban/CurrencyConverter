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
    private let currencyContainerManager = CurrencyContainerManager()
    
    func insertCurrencies() {
        let currencyCount = currencyManager.fetchCurrencyCount()
        if currencyCount > 0 {
            return
        }
        guard
            let path = Bundle.main.path(forResource: "WorldCurrencies", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            return
        }
        
        for dictionary in dataArray {
            if let dictionary = dictionary as? [String: Any] {
                let currency = Currency(from: dictionary)
                currencyManager.createCurrency(currency)
            }
        }
    }
    
    func insertGroups() {
        let groupCount = groupManager.fetchGroupCount()
        if groupCount > 0 { return }
        
        guard
            let popularCurrencies = currencyManager.fetchSpecified(byCurrency: DefaultConstants.popularCurrencies) else {
            return
        }
        createPopularGroup(currencyNumbers: DefaultConstants.popularCurrencies)
        
        var groupKey: Int16 = 0
        guard let currencies = currencyManager.fetchCurrencyExcept(currencies: popularCurrencies) else { return }
        for currency in currencies {
            let groupName = String(currency.code.first ?? " ")
            if
                let groups = groupManager.fetchGroup(by: [groupName]),
                let group = groups.first {
                currencyManager.updateCurrencyGroup(by: [currency.number], with: group.key)
            } else {
                groupKey += 1
                let group = Group(
                    visible: true,
                    name: groupName,
                    key: groupKey)
                groupManager.createGroup(group)
                currencyManager.updateCurrencyGroup(by: [currency.number], with: group.key)
            }
        }
    }
    
    private func createPopularGroup(currencyNumbers: [Int16]) {
        let group = Group(visible: true, name: "Popular", key: Int16(0))
        groupManager.createGroup(group)
        currencyManager.updateCurrencyGroup(by: currencyNumbers, with: group.key)
    }
    
    func createCurrencyContainers() {
        let currencyContainerCount = currencyContainerManager.fetchCurrencyContainerCount()
        if currencyContainerCount > 0 {
            return
        }
        currencyContainerManager.createCurrencyContainers()
    }
    
    func updateContainersWithDefaultCurrencies() {
        updateRatesContainer()
        updateConverterContainer()
    }
    
    private func updateRatesContainer() {
        let containerName = ContainerConstants.Name.rate
        let countInContainer = currencyContainerManager.getCurrencyCountInContainer(name: containerName)
        if countInContainer > 0 { return }
        let currencyNumbers = DefaultConstants.currencies.sorted()
        currencyNumbers.forEach { currencyNumber in
            guard let currency = currencyManager.fetchCurrency(byCurrency: currencyNumber) else { return }
            currencyContainerManager.updateContainer(containerName, with: currency)
        }
    }
    
    private func updateConverterContainer() {
        let containerName = ContainerConstants.Name.converter
        let currencyNumbers = DefaultConstants.currencies
        let countInContainer = currencyContainerManager.getCurrencyCountInContainer(name: containerName)
        if countInContainer > 0 { return }
        guard let currency = currencyManager.fetchCurrency(byCurrency: DefaultConstants.baseCurrency) else {
            return
        }
        currencyContainerManager.updateContainer(containerName, with: currency)
        for currencyNumber in currencyNumbers.sorted() where currencyNumber != 985 {
            guard let currency = currencyManager.fetchCurrency(byCurrency: currencyNumber) else { return }
            currencyContainerManager.updateContainer(containerName, with: currency)
        }
    }
    
    //    func updateContainerWithBaseCurrency() {
    //        let containerName = ContainerConstants.Name.converter
    //        let countInContainer = currencyContainerManager.getCurrencyCountInContainer(name: containerName)
    //        if countInContainer > 0 { return }
    //        guard let currency = currencyManager.fetchCurrency(byCurrency: DefaultConstants.baseCurrency) else {
    //            return
    //        }
    //        currencyContainerManager.updateContainer(containerName, with: currency)
    //    }
}
