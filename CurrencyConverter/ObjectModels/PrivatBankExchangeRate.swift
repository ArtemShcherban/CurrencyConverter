import Foundation

struct PrivatBankExchangeRate: Decodable {
    let buyRate: Double
    let sellRate: Double
    let currencyCode: String
    
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
        let sellRateNB = try values.decode(Double.self, forKey: .saleRateNB)
        let buyRateNB = try values.decode(Double.self, forKey: .purchaseRateNB)
        if
            let sellRateCash = try values.decodeIfPresent(Double.self, forKey: .saleRate),
            let buyRateCash = try values.decodeIfPresent(Double.self, forKey: .purchaseRate)
        {
            self.sellRate = sellRateCash
            self.buyRate = buyRateCash
        } else {
            self.sellRate = sellRateNB + sellRateNB * 0.05
            self.buyRate = buyRateNB
        }
        self.currencyCode = try values.decodeIfPresent(String.self, forKey: .currency) ?? "No Code"
    }
    
    func convertToExchangeRate(currencyList: [Currency]) -> ExchangeRate {
        let exchangeRate = ExchangeRate(from: self, and: currencyList)
        return exchangeRate
    }
}
