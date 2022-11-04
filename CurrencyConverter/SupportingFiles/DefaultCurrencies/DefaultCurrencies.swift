//
//  DefaultCurrencies.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 02.08.2022.
//

import Foundation

enum DefaultCurrencies {
    private static let baseCurrency = 980
        
    static let popularCurrencyNumbers: [Int] = [980, 840, 978]
    static var exRatesCurrenciesNumbers: [Int] = [840, 978, 985]
    static var converterCurrenciesNumbers: [Int] = [baseCurrency, 840, 978]
}
