//
//  MonoBankExchangeRate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct MonoBankExchangeRate: Codable {
    let date: Int
    let buy: Double
    let sell: Double
    let cross: Double
    let currencyNumberA: Int16
    let currencyNumberB: Int16

    enum CodingKeys: String, CodingKey {
        case date
        case buy = "rateBuy"
        case sell = "rateSell"
        case cross = "rateCross"
        case currencyNumberA = "currencyCodeA"
        case currencyNumberB = "currencyCodeB"
    }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            date = try values.decode(Int.self, forKey: .date)
            let buy = try values.decodeIfPresent(Double.self, forKey: .buy) ?? 0.0
            let sell = try values.decodeIfPresent(Double.self, forKey: .sell) ?? 0.0
            cross = try values.decodeIfPresent(Double.self, forKey: .cross) ?? 0.0
            if buy == 0 || sell == 0 {
                self.buy = cross - cross * 0.05
                self.sell = cross + cross * 0.05
            } else {
                self.buy = buy
                self.sell = sell
            }
            currencyNumberA = try values.decode(Int16.self, forKey: .currencyNumberA)
            currencyNumberB = try values.decode(Int16.self, forKey: .currencyNumberB)
        }
    
    func convertToExchangeRate() -> ExchangeRate {
        let exchangeRate = ExchangeRate(from: self)
        return exchangeRate
    }
}


//class MonoBankExchangeRate: BankExchangeRate, Decodable {
//    let date: Int
//    let rateBuy: Double
//    let rateSell: Double
//    let cross: Double
//    let currencyNumberA: Int16
//    let currencyNumberB: Int16
//
//    enum CodingKeys: String, CodingKey {
//        case date
//        case buy = "rateBuy"
//        case sell = "rateSell"
//        case cross = "rateCross"
//        case currencyNumberA = "currencyCodeA"
//        case currencyNumberB = "currencyCodeB"
//    }
//
//    required init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            date = try values.decode(Int.self, forKey: .date)
//            let buy = try values.decodeIfPresent(Double.self, forKey: .buy) ?? 0.0
//            let sell = try values.decodeIfPresent(Double.self, forKey: .sell) ?? 0.0
//            cross = try values.decodeIfPresent(Double.self, forKey: .cross) ?? 0.0
//            if buy == 0 || sell == 0 {
//                self.rateBuy = cross - cross * 0.05
//                self.rateSell = cross + cross * 0.05
//            } else {
//                self.rateBuy = buy
//                self.rateSell = sell
//            }
//            currencyNumberA = try values.decode(Int16.self, forKey: .currencyNumberA)
//            currencyNumberB = try values.decode(Int16.self, forKey: .currencyNumberB)
//        }
//}
