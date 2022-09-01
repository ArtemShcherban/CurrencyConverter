import Foundation
struct  NationalBankRate: Codable {
    let baseCurrency: String
    let currency: String
    let saleRateNB: Double
    let purchaseRateNB: Double
    let saleRate: Double?
    let purchaseRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency
        case currency
        case saleRateNB
        case purchaseRateNB
        case saleRate
        case purchaseRate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseCurrency = try values.decode(String.self, forKey: .baseCurrency)
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? String()
        saleRateNB = try values.decode(Double.self, forKey: .saleRateNB)
        purchaseRateNB = try values.decode(Double.self, forKey: .purchaseRateNB)
        if
            let saleRate = try values.decodeIfPresent(Double.self, forKey: .saleRate),
            let purchaseRate = try values.decodeIfPresent(Double.self, forKey: .purchaseRate)
        {
            self.saleRate = saleRate
            self.purchaseRate = purchaseRate
        } else {
            self.saleRate = saleRateNB + saleRateNB * 0.05
            self.purchaseRate = purchaseRateNB
        }
    }
}
