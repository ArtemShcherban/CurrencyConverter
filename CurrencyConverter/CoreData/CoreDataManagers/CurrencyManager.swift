//
//  CurrencyManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct CurrencyManager {
    private let currencyDateRepositrory = CurrencyDataRepository()
    
    func getCurrencyCount() -> Int {
        currencyDateRepositrory.getCount
    }
    
    func createCurrency(_ currency: Currency) {
        currencyDateRepositrory.create(currency: currency)
    }
    
    func getCurrencyExcept(currencies: [Currency]) -> [Currency]? {
        currencyDateRepositrory.getAllExcept(currencies: currencies)
    }
    
    func getCurrency(by code: String) -> Currency? {
        currencyDateRepositrory.get(byCurrency: code)
    }
    
    func getCurrency(by number: Int) -> Currency? {
        currencyDateRepositrory.get(byCurrency: number)
    }
    
    func updateCurrencyRate(for currency: Currency) {
        currencyDateRepositrory.updateRate(for: currency)
    }
    
    func setGroupKeyForCurrency(with number: Int, with groupKey: Int) {
        currencyDateRepositrory.setGroupKey(forCurrency: number, with: groupKey)
    }
}
