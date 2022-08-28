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
    
//    func fetchCurrencyContainer(for tableViewName: String) -> CurrencyContainer? {
//      currencyContainerDataRepository.get(for: tableViewName)
//    }
    
    func updateContainer(_ container: String, with currency: Currency) {
        currencyContainerDataRepository.update(container: container, with: currency)
    }
}
