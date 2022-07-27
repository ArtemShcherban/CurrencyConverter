//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation

class ConverterMainModel {
    lazy var currencyDataSource = CurrencyDataSource.shared
    
    func createExchangeRates(monobankData: [MonoBankExchangeRate]) {
        var rateBuy = 0.0
        var rateSell = 0.0
        monobankData.forEach {  monoBankExchangeRate in
            let currency = monoBankExchangeRate.currencyCodeA
            let ukrainianHryvna = monoBankExchangeRate.currencyCodeB
            let date = getDataFrom(unixTime: Double(monoBankExchangeRate.date))
            
            if monoBankExchangeRate.rateBuy == 0.0 || monoBankExchangeRate.rateSell == 0.0 {
                let rate = createRateFrom(rateCross: monoBankExchangeRate.rateCross)
                rateBuy = rate.rateBuy
                rateSell = rate.rateSell
            } else {
            rateBuy = monoBankExchangeRate.rateBuy
            rateSell = monoBankExchangeRate.rateSell
            }
            let exchangeRate = ExchangeRate(
                currency: currency,
                ukrainianHryvna: ukrainianHryvna,
                date: date,
                rateBuy: rateBuy,
                rateSell: rateSell)
            currencyDataSource.rates.updateValue(exchangeRate, forKey: currency)
        }
    }
    
    func getDataFrom(unixTime: Double) -> String {
        let data = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = dateFormatter.string(from: data)
        return stringDate
    }
    
    func createRateFrom(rateCross: Double) -> (rateBuy: Double, rateSell: Double) {
        let rateBuy = rateCross - rateCross * 0.05
        let rateSell = rateCross + rateCross * 0.05
        return (rateBuy, rateSell)
    }
}
