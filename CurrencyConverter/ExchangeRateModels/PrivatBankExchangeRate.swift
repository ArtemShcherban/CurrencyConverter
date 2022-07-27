import Foundation

struct PrivatBankExchangeRate: Codable {
	let currency: String
	let baseCurrency: String
	let buy: String
	let sale: String

	enum CodingKeys: String, CodingKey {
		case currency = "ccy"
		case baseCurrency = "base_ccy"
		case buy
		case sale
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		currency = try values.decode(String.self, forKey: .currency)
		baseCurrency = try values.decode(String.self, forKey: .baseCurrency)
		buy = try values.decode(String.self, forKey: .buy)
		sale = try values.decode(String.self, forKey: .sale)
	}
}
