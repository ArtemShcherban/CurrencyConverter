//
//  MockCurrency.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 20.10.2022.
//

import Foundation
@testable import CurrencyConverter

enum MockCurrency {
    static let currencies: [Currency] = [greatBritanPound, canadianDollar, japaneseYen]
    static let currencyCodes: [String] = currencies.map { $0.code }
    static let currencyNumbers: [Int] = currencies.map { $0.number }

    static let greatBritanPound = Currency(
        buy: 40.0,
        sell: 45.0,
        code: "GBP",
        number: 826,
        country: "UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND (THE)",
        groupKey: 7,
        currency: "Pound Sterling",
        container: nil,
        currencyPlural: "Pounds Sterling"
    )
    
    static let canadianDollar = Currency(
        buy: 26.0,
        sell: 28.0,
        code: "CAD",
        number: 124,
        country: "CANADA",
        groupKey: 3,
        currency: "Canadian Dollar",
        container: nil,
        currencyPlural: "Canadian Dollars"
    )
    
    static let japaneseYen = Currency(
        buy: 0.240,
        sell: 0.250,
        code: "JPY",
        number: 392,
        country: "JAPAN",
        groupKey: 10,
        currency: "Japanese Yen",
        container: nil,
        currencyPlural: "Japanese Yen"
    )
    
    static let omaniReal = Currency(
        buy: 92.0,
        sell: 100.0,
        code: "OMR",
        number: 512,
        country: "OMAN",
        groupKey: 15,
        currency: "Omani Real",
        container: nil,
        currencyPlural: "Omani Reals"
    )
    
    static let ukrainianHryvnia = Currency(
        buy: 0.0,
        sell: 0.0,
        code: "UAH",
        number: 980,
        country: "UKRAINE",
        groupKey: 0,
        currency: "Ukrainian Hryvnia",
        container: nil,
        currencyPlural: "Ukrainian Hryvnias"
    )
    
    static let usDollar = Currency(
        buy: 36.0,
        sell: 47.0,
        code: "USD",
        number: 840,
        country: "UNITED STATES OF AMERICA (THE)",
        groupKey: 0,
        currency: "US Dollar",
        container: nil,
        currencyPlural: "US Dollars"
    )
}
