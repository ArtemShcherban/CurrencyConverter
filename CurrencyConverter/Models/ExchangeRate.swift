import Foundation

struct ExchangeRate: Codable {
    let buy: Double
    let sell: Double
    let currencyNumber: Int16
    
    init(from monoBankExchangeRate: MonoBankExchangeRate) {
        self.buy = monoBankExchangeRate.buy
        self.sell = monoBankExchangeRate.sell
        if monoBankExchangeRate.currencyNumberB == 980 {
        self.currencyNumber = monoBankExchangeRate.currencyNumberA
        } else {
        self.currencyNumber = 0
        }
    }
    
    init(from privatBankExchangeRate: NationalBankRate) {
        self.buy = privatBankExchangeRate.purchaseRate
        self.sell = privatBankExchangeRate.saleRate
        self.currencyNumber = privatBankExchangeRate.currency
    }
    
    init(buy: Double, sell: Double, currencyNumber: Int16) {
        self.buy = buy
        self.sell = sell
        self.currencyNumber = currencyNumber
    }
}
