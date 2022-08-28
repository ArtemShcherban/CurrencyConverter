//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct Currency {
    var buy: Double
    var sell: Double
    var code: String
    var number: Int16
    var country: String
    var groupKey: Int16
    var currency: String
    var container: NSOrderedSet?
    var currencyPlural: String
    
    init(buy: Double, sell: Double, code: String, number: Int16, country: String, groupKey: Int16, currency: String, container: NSOrderedSet? = nil, currencyPlural: String) {
        self.buy = buy
        self.sell = sell
        self.code = code
        self.number = number
        self.country = country
        self.groupKey = groupKey
        self.currency = currency
        self.container = container
        self.currencyPlural = currencyPlural
    }
    
    init(from dictionary: [String: Any]) {
        self.buy = 0.0
        self.sell = 0.0
        self.code = dictionary["Code"] as? String ?? String()
        self.number = dictionary["Number"] as? Int16 ?? Int16()
        self.country = dictionary["Country"] as? String ?? String()
        self.groupKey = 0
        self.currency = dictionary["Currency"] as? String ?? String()
        self.container = nil
        self.currencyPlural = dictionary["CurrencyPlural"] as? String ?? String()
    }
}
