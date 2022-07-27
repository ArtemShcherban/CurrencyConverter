//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

struct ExchangeRate {
    let currency: Int
    let ukrainianHryvna: Int
    let date: String
    let rateBuy: Double
    let rateSell: Double
    
    init(
        currency: Int,
        ukrainianHryvna: Int,
        date: String,
        rateBuy: Double,
        rateSell: Double
    ) {
        self.currency = currency
        self.ukrainianHryvna = ukrainianHryvna
        self.date = date
        self.rateBuy = rateBuy
        self.rateSell = rateSell
        }
}
