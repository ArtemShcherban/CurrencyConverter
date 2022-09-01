//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class ExchangeRateModel {
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var dataSource = ResultDataSource.shared
    
    private let exchangeRateManager = ExchangeRateManager()
    private let currencyManager = CurrencyManager()
    
    func createExchangeRate(bankData: [MonoBankExchangeRate]) {
        bankData.forEach { monoBankExchangeRate in
//            exchangeRateManager.deleteExchangeRates()
            if monoBankExchangeRate.currencyNumberB == 980 {
                let exchangeRate = ExchangeRate(from: monoBankExchangeRate)
                exchangeRateManager.createExchangeRate(exchangeRate)
            }
        }
    }
    
    func setExchangeRate(for currency: inout Currency) {
        guard currency.code != "UAH" else {
            currency.buy = 1.0
            currency.sell = 1.0
            currencyManager.updateCurrencyRate(currency)
            return
        }
        guard let exchangeRate = exchangeRateManager.fetchExchangeRate(by: currency.number) else { return }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        currencyManager.updateCurrencyRate(currency)
    }
}
