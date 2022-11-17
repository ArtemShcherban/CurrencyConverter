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
    private(set) lazy var dateModel = DateModel(coreDataStack: ExchangeService.coreDataStack)
    private(set) lazy var ratesModel = RatesModel(coreDataStack: ExchangeService.coreDataStack)
    private(set) lazy var messageModel = MessageModel()
    private(set) lazy var converterModel = ConverterModel()
    private(set) lazy var exchangeRateModel = ExchangeRateModel(
        with: [],
        coreDataStack: ExchangeService.coreDataStack
    )
    
    weak var delegate: MainViewController?
    
    init() {
        self.containerRepository = ContainerRepository(coreDataStack: ExchangeService.coreDataStack)
        let currencies = decodeWorldCurrenciesPList()
        self.exchangeRateModel = ExchangeRateModel(
            with: currencies,
            coreDataStack: ExchangeService.coreDataStack
        )
        updateCurrenciesList(with: currencies)
        createGroups()
        createContainers()
    }
    
    convenience init(coreDataStack: CoreDataStack) {
        ExchangeService.coreDataStack = coreDataStack
        self.init()
    }
    
    func insertCurrencies() {
        self.delegate?.currenciesList = self.currenciesList.map { $0.value }
        self.delegate?.groups = self.groups
    }
    
    private func decodeWorldCurrenciesPList() -> [Currency] {
        let worldCurrenciesURL = Bundle.main.url(forResource: "WorldCurrencies", withExtension: "plist")
        
        let decoder = PropertyListDecoder()
        
        guard
            let url = worldCurrenciesURL,
            let worldCurrenciesData = try? Data(contentsOf: url),
            let currencies = try? decoder.decode([Currency].self, from: worldCurrenciesData) else {
            return []
        }
        return currencies
    }
    
    private func updateCurrenciesList(with currencies: [Currency]) {
        currencies.forEach { currency in
            currenciesList.updateValue(currency, forKey: currency.code)
        }
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
        let containerName = ContainerName.exchangeRates
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
