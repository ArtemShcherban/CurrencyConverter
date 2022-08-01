//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

struct ExchangeRate: Codable {
    let currencyCode: Int
    let currency: String
    let ukrainianHryvna: Int
    let date: String
    let rateBuy: Double
    let rateSell: Double
    
    init(
        currencyCode: Int,
        currency: String,
        ukrainianHryvna: Int,
        date: String,
        rateBuy: Double,
        rateSell: Double
    ) {
        self.currencyCode = currencyCode
        self.currency = currency
        self.ukrainianHryvna = ukrainianHryvna
        self.date = date
        self.rateBuy = rateBuy
        self.rateSell = rateSell
        }
}
