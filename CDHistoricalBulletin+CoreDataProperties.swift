//
//  CDHistoricalBulletin+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//
//

import Foundation
import CoreData

extension CDHistoricalBulletin {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDHistoricalBulletin> {
        return NSFetchRequest<CDHistoricalBulletin>(entityName: "CDHistoricalBulletin")
    }

    @NSManaged public var date: Date?
    @NSManaged public var bank: String?
    @NSManaged public var rates: NSOrderedSet?
}

// MARK: Generated accessors for rates
extension CDHistoricalBulletin {
    @objc(insertObject:inRatesAtIndex:)
    @NSManaged public func insertIntoRates(_ value: CDHistoricalRate, at idx: Int)

    @objc(removeObjectFromRatesAtIndex:)
    @NSManaged public func removeFromRates(at idx: Int)

    @objc(insertRates:atIndexes:)
    @NSManaged public func insertIntoRates(_ values: [CDHistoricalRate], at indexes: NSIndexSet)

    @objc(removeRatesAtIndexes:)
    @NSManaged public func removeFromRates(at indexes: NSIndexSet)

    @objc(replaceObjectInRatesAtIndex:withObject:)
    @NSManaged public func replaceRates(at idx: Int, with value: CDHistoricalRate)

    @objc(replaceRatesAtIndexes:withRates:)
    @NSManaged public func replaceRates(at indexes: NSIndexSet, with values: [CDHistoricalRate])

    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: CDHistoricalRate)

    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: CDHistoricalRate)

    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSOrderedSet)

    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSOrderedSet)
}

extension CDHistoricalBulletin: Identifiable {

}
