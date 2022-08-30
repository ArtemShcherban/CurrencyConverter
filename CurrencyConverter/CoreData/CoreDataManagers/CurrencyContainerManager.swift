//
//  CurrencyContainerManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//

import Foundation

struct CurrencyContainerManager {
    private let currencyContainerDataRepository = CurrencyContainerDataRepository()
    
    func fetchCurrencyContainerCount() -> Int {
        currencyContainerDataRepository.getCount()
    }
    
    func createCurrencyContainers() {
        currencyContainerDataRepository.createCurrenciesContainers()
    }
    
    func getCurrencyCountInContainer(name: String) -> Int {
        currencyContainerDataRepository.getCurrencyCount(inContainer: name)
    }
    
    func getCurrencyFromContainer(name: String) -> [Currency]? {
        currencyContainerDataRepository.getFromContainer(name: name)
    }
    
//    func fetchCurrencyContainer(for tableViewName: String) -> CurrencyContainer? {
//      currencyContainerDataRepository.get(for: tableViewName)
//    }
    
    func updateContainer(_ container: String, with currency: Currency) {
        currencyContainerDataRepository.update(container: container, with: currency)
    }
    
    func replaceCurrency(in container: String, at row: Int, with currency: Currency) {
        currencyContainerDataRepository.replace(inContainer: container, at: row, with: currency)
    }
    
    func deleteCurrency(_ currency: Currency, from conteiner: String) {
        currencyContainerDataRepository.delete(currency: currency, fromContainer: conteiner)
    }
}
