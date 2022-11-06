//
//  ExchangeService.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 18.10.2022.
//

import Foundation
import CoreData

final class ExchangeService {
    static var coreDataStack = CoreDataStack.shared
    let containerRepository: ContainerRepository
    private(set) lazy var currenciesList: [String: Currency] = [:]
    private(set) lazy var groups: [Group] = []
    private(set) lazy var dateModel = DateModel(ExchangeService.coreDataStack)
    private(set) lazy var ratesModel = RatesModel(ExchangeService.coreDataStack)
    private(set) lazy var messageModel = MessageModel()
    private(set) lazy var converterModel = ConverterModel()
    private(set) lazy var exchangeRateModel = ExchangeRateModel(
        with: [],
        coreDataStack: ExchangeService.coreDataStack
    )
    
    weak var delegate: MainViewController?
    
    init() {
        self.containerRepository = ContainerRepository(
            ExchangeService.coreDataStack,
            managedObjectContext: ExchangeService.coreDataStack.managedContext)
        createCurrencies {
            self.exchangeRateModel = ExchangeRateModel(
                with: self.currenciesList.map { $0.value },
                coreDataStack: ExchangeService.coreDataStack
            )
        }
    }
    
    convenience init(_ coreDataStack: MockCoreDataStack) {
        ExchangeService.coreDataStack = coreDataStack
        self.init()
    }
    
    func insertCurrencies() {
        self.delegate?.currenciesList = self.currenciesList.map { $0.value }
        self.delegate?.groups = self.groups
    }
    
    private func createCurrencies(complition: @escaping () -> Void) {
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
        self.createGroups()
        self.createContainers()
        complition()
    }
    
    private func createGroups() {
        var popularCurrencies: [Currency] = []
        var otherCurrencies = currenciesList.map { $0.value }
        
        DefaultCurrencies.popularCurrencyNumbers.forEach { number in
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
            let currencyCopy = currency
            currencyCopy.groupKey = groupKey
            currenciesList.updateValue(currencyCopy, forKey: currencyCopy.code)
        }
    }
    
    private func createPopularGroup(from currencies: [Currency]) {
        let group = Group(visible: true, name: TitleConstants.popular, key: 0)
        currencies.forEach { popularCurrency in
            if let currency = currenciesList.first(where: { element in
                element.key == popularCurrency.code
            })?.value {
                currency.groupKey = group.key
                currenciesList.updateValue(currency, forKey: currency.code)
            }
        }
        groups.append(group)
    }
    
    private func createContainers() {
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
        let containerName = ContainerName.exRates
        let currencyNumbers = DefaultCurrencies.exRatesCurrenciesNumbers
        currencyNumbers.forEach { currencyNumber in
            if let currency = currenciesList.first(where: { $0.value.number == currencyNumber })?.value {
                containerRepository.update(container: containerName, with: currency)
            }
        }
    }
    
    private func updateConverterContainer() {
        let containerName = ContainerName.converter
        let currencyNumbers = DefaultCurrencies.converterCurrenciesNumbers
        
        currencyNumbers.forEach { currencyNumber in
            guard let currency = currenciesList.first(where: { $0.value.number == currencyNumber })?
                .value else {
                return
            }
            containerRepository.update(container: containerName, with: currency)
        }
    }
}
