import Foundation

struct PrivatBankExchangeRate: Codable {
	let buy: String
	let sale: String
    let currency: String
    let baseCurrency: String

	enum CodingKeys: String, CodingKey {
        case buy
        case sale
		case currency = "ccy"
		case baseCurrency = "base_ccy"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
//        buy = try values.decode(String.self, forKey: .buy)
//        sale = try values.decode(String.self, forKey: .sale)
//		currency = try values.decode(String.self, forKey: .currency)
//		baseCurrency = try values.decode(String.self, forKey: .baseCurrency)
        
        buy = "try values.decode(String.self, forKey: .buy)"
        sale = "try values.decode(String.self, forKey: .sale)"
        currency = "try values.decode(String.self, forKey: .currency)"
        baseCurrency = "try values.decode(String.self, forKey: .baseCurrency)"
	}
}
