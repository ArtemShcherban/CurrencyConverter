//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct Currency: Equatable, Decodable {
    enum CurrencyInitError: Error {
        case cannotDecodeValues
    }
    
    var buy: Double = 0.0
    var sell: Double = 0.0
    var code: String = "No Code"
    var number: Int = 0
    var country: String = "No Country"
    var groupKey: Int = 0
    var currency: String = "No Currency Name"
    var container: NSOrderedSet?
    var currencyPlural: String = "No Plural"
    
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case number = "Number"
        case country = "Country"
        case currency = "Currency"
        case currencyPlural = "CurrencyPlural"
    }
    
    init(from decoder: Decoder) throws {
        guard let values = try? decoder.container(keyedBy: CodingKeys.self) else {
            throw CurrencyInitError.cannotDecodeValues
        }
        self.code = try values.decode(String.self, forKey: .code)
        self.number = try values.decode(Int.self, forKey: .number)
        self.country = try values.decode(String.self, forKey: .country)
        self.currency = try values.decode(String.self, forKey: .currency)
        self.currencyPlural = try values.decode(String.self, forKey: .currencyPlural)
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.number == rhs.number &&
        lhs.code == rhs.code
    }
}
