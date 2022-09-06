//
//  CDCurrency+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//
//

import Foundation
import CoreData

@objc(CDCurrency)
public class CDCurrency: NSManagedObject {
    func convertToCurrency() -> Currency {
        let currency = Currency(
            buy: self.buy,
            sell: self.sell,
            code: self.code,
            number: self.number,
            country: self.country,
            groupKey: self.groupKey,
            currency: self.currency,
            container: self.container,
            currencyPlural: self.currencyPlural)
        return currency
    }
}
