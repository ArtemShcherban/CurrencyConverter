//
//  CDExchangeRate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 04.08.2022.
//
//

import Foundation
import CoreData

extension CDExchangeRate {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDExchangeRate> {
        return NSFetchRequest<CDExchangeRate>(entityName: "CDExchangeRate")
    }

    @NSManaged public var buy: Double
    @NSManaged public var sell: Double
    @NSManaged public var currencyNumber: Int16
}

extension CDExchangeRate: Identifiable {
}
