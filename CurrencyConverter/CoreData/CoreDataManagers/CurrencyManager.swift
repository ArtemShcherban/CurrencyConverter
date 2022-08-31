//
//  CurrencyManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct CurrencyManager {
    private let currencyDateRepositrory = CurrencyDataRepository()
    
    func fetchCurrencyCount() -> Int {
        currencyDateRepositrory.getCount()
    }
    
    func createCurrency(_ currency: Currency) {
        currencyDateRepositrory.create(currency: currency)
    }
    
    func fetchCurrencyExcept(currencies: [Currency]) -> [Currency]? {
        currencyDateRepositrory.getAllExcept(currencies: currencies)
    }
    
    func fetchSpecified(byCurrency numbers: [Int16]) -> [Currency]? {
        currencyDateRepositrory.getSpecified(by: numbers)
    }
    
    func fetchCurrency(byCurrency number: Int16) -> Currency? {
        currencyDateRepositrory.get(byCurrency: number)
    }
    
    func updateCurrencyRate(_ currency: Currency) {
        currencyDateRepositrory.updateCurrencyRate(currency: currency)
    }
    
    func updateCurrencyGroup(by currencyNumbers: [Int16], with groupKey: Int16) {
        currencyDateRepositrory.updateCurrencyGroup(byCurrency: currencyNumbers, with: groupKey)
    }
}
