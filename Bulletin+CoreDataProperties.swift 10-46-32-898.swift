//
//  Bulletin+CoreDataProperties.swift
//  
//
//  Created by Artem Shcherban on 04.08.2022.
//
//

import Foundation
import CoreData

extension Bulletin {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<Bulletin> {
        return NSFetchRequest<Bulletin>(entityName: "Bulletin")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var rates: NSOrderedSet?
}

// MARK: Generated accessors for rates
extension Bulletin {
    @objc(insertObject:inRatesAtIndex:)
    @NSManaged public func insertIntoRates(_ value: ExchangeRate, at idx: Int)
    
    @objc(removeObjectFromRatesAtIndex:)
    @NSManaged public func removeFromRates(at idx: Int)
    
    @objc(insertRates:atIndexes:)
    @NSManaged public func insertIntoRates(_ values: [ExchangeRate], at indexes: NSIndexSet)
    
    @objc(removeRatesAtIndexes:)
    @NSManaged public func removeFromRates(at indexes: NSIndexSet)
    
    @objc(replaceObjectInRatesAtIndex:withObject:)
    @NSManaged public func replaceRates(at idx: Int, with value: ExchangeRate)
    
    @objc(replaceRatesAtIndexes:withRates:)
    @NSManaged public func replaceRates(at indexes: NSIndexSet, with values: [ExchangeRate])
    
    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: ExchangeRate)
    
    @objc(removeRatesObject:)
    @NSManaged public func removeFromRates(_ value: ExchangeRate)
    
    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSOrderedSet)
    
    @objc(removeRates:)
    @NSManaged public func removeFromRates(_ values: NSOrderedSet)
}
