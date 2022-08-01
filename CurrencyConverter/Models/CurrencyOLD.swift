import Foundation

struct CurrencyOLD: Codable, Hashable {
    let country: String
    let currencyName: String
    let currency: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case currencyName = "CurrencyName"
        case currency = "Currency"
        case code = "Code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decode(String.self, forKey: .country)
        currencyName = try values.decode(String.self, forKey: .currencyName)
        currency = try values.decode(String.self, forKey: .currency)
        code = try values.decode(Int.self, forKey: .code)
    }
    
    init(
        country: String,
        currencyName: String,
        currency: String,
        code: Int
    ) {
        self.country = country
        self.currencyName = currencyName
        self.currency = currency
        self.code = code
    }
    
    static func == (lhs: CurrencyOLD, rhs: CurrencyOLD) -> Bool {
        lhs.code == rhs.code
    }
}
