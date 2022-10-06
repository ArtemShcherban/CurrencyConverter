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
    private let currencyRepository = CurrencyDataRepository()
    lazy var selectedDate = Date().startOfDay
    
    func convertToExchangeRates<T>(bankRates: [T]) -> [ExchangeRate] {
        var exchangeRates: [ExchangeRate] = []
        if let privatExchangeRates = bankRates as? [PrivatBankExchangeRate] {
            privatExchangeRates.forEach {
                exchangeRates.append( $0.convertToExchangeRate())
            }
        }
        if let monoExchangeRates = bankRates as? [MonoBankExchangeRate] {
            monoExchangeRates.forEach {
                exchangeRates.append( $0.convertToExchangeRate())
            }
        }
        return exchangeRates
    }
    
    func isBulletinInDatabase(for date: Date) -> Bool {
        return exchangeRateManager.checkBulletinInDatabase(for: date.startOfDay)
    }
    
    func updateBulletin(for date: Date, bankData: [ExchangeRate]) {
        if !exchangeRateManager.checkBulletinInDatabase(for: date.startOfDay) {
            exchangeRateManager.createBulletin(Bulletin(
                from: "\(date.yyyyMMdd) \(TitleConstants.bankName)",
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
            currencyRepository.updateCurrencyRate(for: currency)
            return currency
        }
        guard
            let exchangeRate = exchangeRateManager.getExchangeRate(for: currency, on: selectedDate) else {
            return currency
        }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        currencyRepository.updateCurrencyRate(for: currency)
        return currency
    }
    
    func removeOldExchangeRates() {
        exchangeRateManager.deleteBulletin(before: Date().oneYearAgo)
    }
}
