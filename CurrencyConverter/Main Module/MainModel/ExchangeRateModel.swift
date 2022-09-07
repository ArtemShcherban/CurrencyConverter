//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class ExchangeRateModel {
    static let shared = ExchangeRateModel()
    
    private let exchangeRateManager = ExchangeRateManager()
    private let currencyManager = CurrencyManager()
    
    lazy var selectedDate = Date().startOfDay
    
    func isBulletinInDatabase(for date: Date) -> Bool {
        return exchangeRateManager.checkBulletinInDatabase(for: date.startOfDay)
    }
    
    func updateBulletin(for date: Date, bankData: [ExchangeRate]) {
        if !exchangeRateManager.checkBulletinInDatabase(for: date.startOfDay) {
            print(date.timeIntervalSinceReferenceDate)
            exchangeRateManager.createBulletin(Bulletin(
                from: "\(date.yyyyMMdd) MonoBank&PrivatBank",
                date: date.startOfDay)
            )
        }
        updateExchangeRates(of: date.startOfDay, with: bankData)
    }
    
    private func updateExchangeRates(of date: Date, with bankData: [ExchangeRate]) {
        bankData.forEach { exchangeRate in
            if exchangeRate.currencyNumber != 0 {
                exchangeRateManager.saveExchangeRate(exchangeRate, date.startOfDay)
            }
        }
    }
    
    func setExchangeRate(for currency: Currency) -> Currency {
        var currency = currency
        guard currency.code != "UAH" else {
            currency.buy = 1.0
            currency.sell = 1.0
            currencyManager.updateCurrencyRate(currency)
            return currency
        }
        guard
            let exchangeRate = exchangeRateManager.fetchExchangeRate(for: currency, on: selectedDate) else {
            return currency
        }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        currencyManager.updateCurrencyRate(currency)
        return currency
    }
    
    func removeOldExchangeRates() {
        exchangeRateManager.deleteExchangeRates(before: Date().oneYearAgo)
    }
}
