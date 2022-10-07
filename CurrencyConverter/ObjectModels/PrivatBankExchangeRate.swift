import Foundation

struct PrivatBankExchangeRate: Decodable {
    let buyRate: Double
    let sellRate: Double
    let currencyNumber: Int
    
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
        let code = try values.decodeIfPresent(String.self, forKey: .currency) ?? "OOO"
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
        self.currencyNumber = getCurrencyNumber(by: code) ?? 0
        
        func getCurrencyNumber(by code: String) -> Int? {
            let currencyRepository = CurrencyRepository()
            let baseCurrency = currencyRepository.currency(by: code)?.number
            return baseCurrency
        }
    }
    
    func convertToExchangeRate() -> ExchangeRate {
        let exchangeRate = ExchangeRate(from: self)
        return exchangeRate
    }
}
