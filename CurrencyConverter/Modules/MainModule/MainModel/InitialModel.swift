//
//  InitialModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//

import Foundation

final class InitialModel {
    private let containerRepository = ContainerRepository(CoreDataStack.shared)
    private lazy var currenciesList: [String: Currency] = [:]
    private lazy var groups: [Group] = []
    
    weak var delegate: MainViewController?
    
    func insertCurrencies(complition: @escaping () -> Void) {
        guard currenciesList.isEmpty else { return }
        guard
            let path = Bundle.main.path(forResource: "WorldCurrencies", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else {
            return
        }
        
        for dictionary in dataArray {
            if let dictionary = dictionary as? [String: Any] {
                let currency = Currency(from: dictionary)
                self.currenciesList.updateValue(currency, forKey: currency.code)
            }
        }
        self.insertGroups()
        self.createContainers()
        delegate?.currenciesList = currenciesList.map { $0.value }
        delegate?.groups = groups
        complition()
    }
    
    func insertGroups() {
        var popularCurrencies: [Currency] = []
        var otherCurrencies = currenciesList.map { $0.value }
        
        DefaultConstants.popularCurrencyNumbers.forEach { number in
            if let currency = currenciesList.first(where: { element in
                element.value.number == number
            })?.value {
                popularCurrencies.append(currency)
                otherCurrencies = otherCurrencies.filter { $0.code != currency.code }
            }
        }
        
        createPopularGroup(from: popularCurrencies)
        
        var groupKey = 0
        
        for currency in otherCurrencies.sorted(by: { $0.code < $1.code }) {
            let groupName = String(currency.code.first ?? " ")
            if !groups.contains(where: { $0.name == groupName }) {
                groupKey += 1
                let group = Group(
                    visible: true,
                    name: groupName,
                    key: Int(groupKey)
                )
                groups.append(group)
            }
            var currencyCopy = currency
            currencyCopy.groupKey = groupKey
            currenciesList.updateValue(currencyCopy, forKey: currencyCopy.code)
        }
    }
    
    private func createPopularGroup(from currencies: [Currency]) {
        let group = Group(visible: true, name: TitleConstants.popular, key: 0)
        currencies.forEach { popularCurrency in
            if var currency = currenciesList.first(where: { element in
                element.key == popularCurrency.code
            })?.value {
                currency.groupKey = group.key
                currenciesList.updateValue(currency, forKey: currency.code)
            }
        }
        groups.append(group)
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
        let currencyNumbers = DefaultConstants.currenciesNumbers.sorted()
        currencyNumbers.forEach { currencyNumber in
            if let currency = currenciesList.first(where: { $0.value.number == currencyNumber })?.value {
                containerRepository.fillIn(container: containerName, with: currency)
            }
        }
    }
    
    private func updateConverterContainer() {
        let containerName = ContainerConstants.Name.converter
        let currencyNumbers = DefaultConstants.currenciesNumbers
        guard let currency = currenciesList.first(where: {
            $0.value.number == DefaultConstants.baseCurrencyNumber })?.value
        else {
            return
        }
        containerRepository.fillIn(container: containerName, with: currency)
        for currencyNumber in currencyNumbers.sorted() where currencyNumber != 985 {
            guard let currency = currenciesList.first(where: {
                $0.value.number == currencyNumber })?.value
            else {
                return
            }
            containerRepository.fillIn(container: containerName, with: currency)
        }
    }
}
