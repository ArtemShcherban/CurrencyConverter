//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class ExchangeRateModel {
    private let bulletinManager = BulletinManager()
    private let exchangeRateManager = ExchangeRateManager()
    private let currencyManager = CurrencyManager()
    
    func fetchBulletin(of date: Date) -> Bulletin? {
        guard let bulletin = bulletinManager.fetchBulletin(of: date) else {
            return nil
        }
        return bulletin
    }
    
    func updateBulletin(for date: Date, bankData: [ExchangeRate]) {
        if bulletinManager.fetchBulletin(of: date.startOfDay) != nil {
        } else {
            bulletinManager.createBulletin(Bulletin(from: "MonoBank&PrivatBank", date: date.startOfDay))
        }
        updateExchangeRates(of: date.startOfDay, with: bankData)
    }
    
    private func updateExchangeRates(of date: Date, with bankData: [ExchangeRate]) {
        bankData.forEach { exchangeRate in
            if exchangeRate.currencyNumber != 0 {
                bulletinManager.saveExchangeRate(exchangeRate, date.startOfDay)
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
