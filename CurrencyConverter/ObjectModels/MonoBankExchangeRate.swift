//
//  MonoBankExchangeRate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct MonoBankExchangeRate: Decodable {
    let buyRate: Double
    let sellRate: Double
    let currencyNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case rateBuy
        case rateSell
        case rateCross
        case currencyCodeA
        case currencyCodeB
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let buy = try values.decodeIfPresent(Double.self, forKey: .rateBuy) ?? 0.0
        let sell = try values.decodeIfPresent(Double.self, forKey: .rateSell) ?? 0.0
        let crossRate = try values.decodeIfPresent(Double.self, forKey: .rateCross) ?? 0.0
        let baseCurrencyNumber = try values.decode(Int.self, forKey: .currencyCodeB)
        if buy == 0 || sell == 0 {
            self.buyRate = crossRate - crossRate * 0.05
            self.sellRate = crossRate + crossRate * 0.05
        } else {
            self.buyRate = buy
            self.sellRate = sell
        }
        if baseCurrencyNumber == 980 {
            self.currencyNumber = try values.decode(Int.self, forKey: .currencyCodeA)
        } else {
            self.currencyNumber = 0
        }
    }
    
    func convertToExchangeRate() -> ExchangeRate {
        let exchangeRate = ExchangeRate(from: self)
        return exchangeRate
    }
}
