//
//  CDExchangeRate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
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
    @NSManaged public var currencyNumber: Int16
    @NSManaged public var sell: Double
    @NSManaged public var bulletin: CDBulletin
}

extension CDExchangeRate: Identifiable {
}
