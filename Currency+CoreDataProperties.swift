//
//  Currency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 07.08.2022.
//
//

import Foundation
import CoreData

extension Currency {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String
    @NSManaged public var country: String
    @NSManaged public var currency: String
    @NSManaged public var groupKey: Int16
    @NSManaged public var number: Int16
    @NSManaged public var selected: Bool
    @NSManaged public var sequenceId: Int16
    @NSManaged public var buy: Double
    @NSManaged public var sell: Double
}

extension Currency: Identifiable {
}
