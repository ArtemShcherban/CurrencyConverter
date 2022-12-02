//
//  MockExRate.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 30.10.2022.
//

import Foundation
@testable import CurrencyConverter

enum MockExRate {
    static let exRates = [gbpExRate, cadExRate, jpyExRate]

    static let gbpExRate = ExchangeRate(buy: 50, sell: 60, currencyNumber: 826)
    static let cadExRate = ExchangeRate(buy: 30, sell: 35, currencyNumber: 124)
    static let jpyExRate = ExchangeRate(buy: 0.300, sell: 0.350, currencyNumber: 392)
}
