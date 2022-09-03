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

//https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2014
// https://api.openweathermap.org/data/2.5/weather?q=London&appid=59a2b233df10c0b64ce48ebeb844ddf2
// https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5

