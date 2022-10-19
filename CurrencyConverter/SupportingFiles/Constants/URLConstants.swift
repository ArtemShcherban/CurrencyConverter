//
//  URLConstants.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 21.07.2022.
//

import Foundation

enum URLConstants {
    enum MonoBank {
        static let scheme = "https"
        static let baseURL = "api.monobank.ua"
        static let path = "/bank/currency"
    }
    
    enum PrivatBank {
        static let scheme = "https"
        static let baseURL = "api.privatbank.ua"
        static let path = "/p24api/exchange_rates"
        static let query = "json"
        static let date = "date"
    }
}
