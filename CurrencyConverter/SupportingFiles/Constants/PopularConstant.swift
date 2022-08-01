//
//  PopularConstant.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.07.2022.
//

import Foundation

enum PopularConstant {
    static let currencies: [Currency] = [
    Currency(country: "THE UNITED STATES OF AMERICA", currencyName: "US Dollar", currency: "USD", code: 840),
    Currency(country: "EUROPEAN UNION", currencyName: "Euro", currency: "EUR", code: 978),
    Currency(country: "UKRAINE", currencyName: "Ukrainian Hryvnia", currency: "UAH", code: 980)
    ]
}
