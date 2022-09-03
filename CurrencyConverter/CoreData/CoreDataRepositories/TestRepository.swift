//
//  TestRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 02.09.2022.
//

import Foundation

//    func handleSaving(exchangeRate: ExchangeRate, _ date: Date) {
//        guard let cdBulletin = getCDBulletin(of: date) else {
//            print("Enable to handle saving the \(exchangeRate)")
//            return
//        }
//        guard let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate] else { return }
//        guard let cdExchangeRate = cdExchangeRates.filter { cdExchangeRate in
//            cdExchangeRate.currencyNumber == exchangeRate.currencyNumber }.first else {
//                createCD(exchangeRate: exchangeRate)
//                return
//            }
//        update(cdExchangeRate: cdExchangeRate)
//    }
    
//    func handleSaving(exchangeRate: ExchangeRate, _ date: Date) {
//        guard let cdBulletin = getCDBulletin(of: date) else {
//            print("Enable to handle saving the \(exchangeRate)")
//            return
//        }
//        guard let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate] else { return }
//        guard let cdExchangeRate = cdExchangeRates.first(where: {
//            $0.currencyNumber == exchangeRate.currencyNumber}) else {
//            createCD(exchangeRate: exchangeRate)
//            return
//        }
//        update(cdExchangeRate: cdExchangeRate)
//    }
