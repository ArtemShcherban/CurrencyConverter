//
//  ExchangeRateManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation

struct ExchangeRateManager {
    let exchangeRateDataRepository = ExchangeRateDataRepository()
    
    func createBulletin(_ bulletin: Bulletin) {
        exchangeRateDataRepository.create(bulletin: bulletin)
    }
    
    func checkBulletinInDatabase(for date: Date) -> Bool {
        return exchangeRateDataRepository.checkBulletin(for: date)
    }
    
    func fetchExchangeRate(for currency: Currency, on date: Date) -> ExchangeRate? {
        exchangeRateDataRepository.getExchangeRate(for: currency, on: date)
    }
    
    func saveExchangeRate(_ exchangeRate: ExchangeRate, _ date: Date) {
        exchangeRateDataRepository.handleSaving(exchangeRate: exchangeRate, on: date)
    }
    
    func deleteExchangeRates(before date: Date) {
        exchangeRateDataRepository.deleteBulletinAndRates(before: date)
    }
}
