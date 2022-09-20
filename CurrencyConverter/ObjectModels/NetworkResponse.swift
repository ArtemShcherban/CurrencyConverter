//
//  NetworkResponse.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.09.2022.
//

import Foundation

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped?
    
    enum CodingKeys: String, CodingKey {
        case exchangeRate
    }
    
    init(from decoder: Decoder) throws {
        guard let values = try? decoder.container(keyedBy: CodingKeys.self) else {
            var values = try decoder.unkeyedContainer()
            var rates: [MonoBankExchangeRate] = []
            while values.isAtEnd == false {
                let rate = try values.decode(MonoBankExchangeRate.self)
                rates.append(rate)
            }
            result = rates as? Wrapped
            return
        }
        result = try values.decode(Wrapped.self, forKey: .exchangeRate)
    }
}
