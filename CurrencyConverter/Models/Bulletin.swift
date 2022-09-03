//
//  Bulletin.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation

struct Bulletin {
    var date: Date
    var bank: String
    var rates: [ExchangeRate]
    
    init(from bank: String, date: Date) {
        self.date = date
        self.bank = bank
        self.rates = []
    }
}


