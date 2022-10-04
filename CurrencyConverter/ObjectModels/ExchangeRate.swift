import Foundation

struct ExchangeRate: Codable {
    let buy: Double
    let sell: Double
    let currencyNumber: Int
    
    init(from monoBankExchangeRate: MonoBankExchangeRate) {
        self.buy = monoBankExchangeRate.buyRate
        self.sell = monoBankExchangeRate.sellRate
        self.currencyNumber = monoBankExchangeRate.currencyNumber
    }
    
    init(from privatBankExchangeRate: PrivatBankExchangeRate) {
        self.buy = privatBankExchangeRate.buyRate
        self.sell = privatBankExchangeRate.sellRate
        self.currencyNumber = privatBankExchangeRate.currencyNumber
    }
    
    init(buy: Double, sell: Double, currencyNumber: Int) {
        self.buy = buy
        self.sell = sell
        self.currencyNumber = currencyNumber
    }
}
