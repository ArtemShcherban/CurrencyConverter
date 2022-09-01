//
//  CDHistoricalRate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//
//

import Foundation
import CoreData

extension CDHistoricalRate {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDHistoricalRate> {
        return NSFetchRequest<CDHistoricalRate>(entityName: "CDHistoricalRate")
    }

    @NSManaged public var buy: Double
    @NSManaged public var sell: Double
    @NSManaged public var currencyNumber: Int16
}

extension CDHistoricalRate: Identifiable {
}
