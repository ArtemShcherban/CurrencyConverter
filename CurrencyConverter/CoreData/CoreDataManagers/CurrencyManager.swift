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
    func fetchCurrency() -> [Currency]? {
        currencyDateRepositrory.getAll()
    }
    
    func fetchCurrencyExcept(currencies: [Currency]) -> [Currency]? {
        currencyDateRepositrory.getAllExcept(currencies: currencies)
    }
    
    func fetchCurrency(byCurrency number: Int16) -> Currency? {
        currencyDateRepositrory.get(byCurrency: number)
    }
    
    func updateCurrency(_ currency: Currency) {
        currencyDateRepositrory.update(currency: currency)
    }
    
    func deleteCurrency(byCurrency number: Int16) {
        currencyDateRepositrory.delete(byCurrency: number)
    }
}
