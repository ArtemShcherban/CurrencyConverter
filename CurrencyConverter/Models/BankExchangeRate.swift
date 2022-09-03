//
//  BankExchangeRate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 02.09.2022.
//

import Foundation

//struct BankExchangeRate: Decodable {
//    var buy: Double
//    var sell: Double
//    var currencyNumber: Int16
//    var exchangeRates: [NationalBankRate] = []
//
//    enum CodingKeys: String, CodingKey {
//        case buy = "rateBuy"
//        case sell = "rateSell"
//        case cross = "rateCross"
//        case currencyNumberA = "currencyCodeA"
//        case currencyNumberB = "currencyCodeB"
//
//        case date
//        case bank
//        case baseCurrency
//        case baseCurrencyLit
//        case exchangeRate
//
//        case currency
//        case saleRateNB
//        case purchaseRateNB
//        case saleRate
//        case purchaseRate
//    }
//}

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let exchangeRates = try values.decodeIfPresent([NationalBankRate].self, forKey: .exchangeRate) {
//            buy = try values.decodeIfPresent(Double.self, forKey: .buy) ?? 55555
//            sell = try values.decodeIfPresent(Double.self, forKey: .sell) ?? 6666
//            currencyNumber = try values.decodeIfPresent(Int16.self, forKey: .currencyNumberA) ?? 4444
//            self.exchangeRates = exchangeRates
//        } else {
//            buy = try values.decodeIfPresent(Double.self, forKey: .buy) ?? 0.777
//            sell = try values.decodeIfPresent(Double.self, forKey: .sell) ?? 0.888
//            currencyNumber = try values.decodeIfPresent(Int16.self, forKey: .currencyNumberA) ?? 8888
//        }
//    }
//}
//class BankExchangeRate {
//    var buy: Double
//    var sell: Double
//    var currencyNumber: Int16
//
//    init(from mbExchangeRate: MonoBankExchangeRate) {
//        self.buy = mbExchangeRate.buy
//        self.sell = mbExchangeRate.sell
//        self.currencyNumber = mbExchangeRate.currencyNumberA
//    }
//
//    init(from pbExchangeRate: NationalBankRate) {
//        self.buy = pbExchangeRate.saleRateNB
//        self.sell = pbExchangeRate.saleRateNB
//        self.currencyNumber = 9999
//    }
//}
