//
//  MainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 15.10.2022.
//

import Foundation

struct MainModel {
    var date = DateModel()
    var rates = RatesModel()
    var message = MessageModel()
    var converter = ConverterModel()
    var exchangeRate: ExchangeRateModel
    
    init(initWith currenciesList: [Currency]) {
        self.exchangeRate = ExchangeRateModel(with: currenciesList)
    }
}
