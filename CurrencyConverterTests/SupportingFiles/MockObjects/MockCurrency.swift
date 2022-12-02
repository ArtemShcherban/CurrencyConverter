//
//  MockCurrency.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 20.10.2022.
//

import Foundation
@testable import CurrencyConverter

enum MockCurrency {
    private static let exchangeService = ExchangeService(coreDataStack: MockCoreDataStack.create())
    private static let currenciesList = exchangeService.currenciesList
    
    static let currencies: [Currency] = [greatBritanPound, canadianDollar, japaneseYen]
    static let currencyCodes: [String] = currencies.map { $0.code }
    static let currencyNumbers: [Int] = currencies.map { $0.number }
    
    static let greatBritanPound: Currency = {
        var currency = currenciesList["GBP"] ?? Currency()
        currency.buy = 40.0
        currency.sell = 45
        return currency
    }()
    
    static let canadianDollar: Currency = {
        var currency = currenciesList["CAD"] ?? Currency()
        currency.buy = 26.0
        currency.sell = 28.0
        return currency
    }()
    
    static let japaneseYen: Currency = {
        var currency = currenciesList["JPY"] ?? Currency()
        currency.buy = 0.240
        currency.sell = 0.250
        return currency
    }()
    
    static let omaniReal = currenciesList["OMR"] ?? Currency()
    static let ukrainianHryvnia = currenciesList["UAH"] ?? Currency()
    static let usDollar = currenciesList["USD"] ?? Currency()
}
