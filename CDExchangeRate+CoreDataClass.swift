//
//  CDExchangeRate+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 04.08.2022.
//
//

import Foundation
import CoreData

@objc(CDExchangeRate)
public class CDExchangeRate: NSManagedObject {
    func convertToExchangeRate() -> ExchangeRate {
        let exchangeRate = ExchangeRate(
            buy: self.buy,
            sell: self.sell,
            currencyNumber: Int(self.currencyNumber))
        return exchangeRate
    }
}
