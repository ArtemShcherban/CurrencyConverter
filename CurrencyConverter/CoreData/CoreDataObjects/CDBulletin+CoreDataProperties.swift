//
//  CDBulletin+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//
//

import Foundation
import CoreData

extension CDBulletin {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDBulletin> {
        return NSFetchRequest<CDBulletin>(entityName: "CDBulletin")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var bank: String
    @NSManaged public var rates: NSOrderedSet
}

// MARK: Generated accessors for rates
extension CDBulletin {
    @objc(insertObject:inRatesAtIndex:)
    @NSManaged public func insertIntoRates(_ value: CDExchangeRate, at idx: Int)

    @objc(removeObjectFromRatesAtIndex:)
    @NSManaged public func removeFromRates(at idx: Int)

    @objc(insertRates:atIndexes:)
    @NSManaged public func insertIntoRates(_ values: [CDExchangeRate], at indexes: NSIndexSet)

    @objc(removeRatesAtIndexes:)
    @NSManaged public func removeFromRates(at indexes: NSIndexSet)

    @objc(replaceObjectInRatesAtIndex:withObject:)
    @NSManaged public func replaceRates(at idx: Int, with value: CDExchangeRate)

    @objc(replaceRatesAtIndexes:withRates:)
    @NSManaged public func replaceRates(at indexes: NSIndexSet, with values: [CDExchangeRate])

    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: CDExchangeRate)

    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: CDExchangeRate)

    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSOrderedSet)

    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSOrderedSet)
}

extension CDBulletin: Identifiable {
}
