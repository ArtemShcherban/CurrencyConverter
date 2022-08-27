import Foundation

struct ExchangeRate: Codable {
    let buy: Double
    let sell: Double
    let currencyNumber: Int
    
    init(from monoBankExchangeRate: MonoBankExchangeRate) {
        self.buy = monoBankExchangeRate.buy
        self.sell = monoBankExchangeRate.sell
        self.currencyNumber = monoBankExchangeRate.currencyNumberA
    }
    
    init(buy: Double, sell: Double, currencyNumber: Int) {
        self.buy = buy
        self.sell = sell
        self.currencyNumber = currencyNumber
    }
}
