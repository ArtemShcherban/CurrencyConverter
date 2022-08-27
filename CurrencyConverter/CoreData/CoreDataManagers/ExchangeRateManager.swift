//
//  ExchangeRateManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct ExchangeRateManager {
    private let exchangeRateDataReository = ExchangeRateDataRepository()
    
    func createExchangeRate(_ exchangeRate: ExchangeRate) {
        exchangeRateDataReository.create(exchangeRate: exchangeRate)
    }
    
    func fetchExchangeRate() -> [ExchangeRate]? {
        exchangeRateDataReository.getAll()
    }
    
    func fetchExchangeRate(by currencyNumber: Int16) -> ExchangeRate? {
        exchangeRateDataReository.get(byCurrency: currencyNumber)
    }
    
    func updateExchangeRate(_ exchangeRate: ExchangeRate) {
        exchangeRateDataReository.update(exchangeRate: exchangeRate)
    }
    
    func deleteExchangeRate(by currencyNumber: Int16) {
        exchangeRateDataReository.delete(byCurrency: currencyNumber)
    }
}
