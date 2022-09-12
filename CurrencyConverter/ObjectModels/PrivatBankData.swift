import Foundation

struct PrivatBankData: Decodable {
    let exchangeRates: [PrivatBankExchangeRate]
    
    enum CodingKeys: String, CodingKey {
        case exchangeRate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        exchangeRates = try values.decode([PrivatBankExchangeRate].self, forKey: .exchangeRate)
    }
}
