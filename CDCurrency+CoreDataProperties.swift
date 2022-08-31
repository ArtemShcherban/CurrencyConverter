//
//  CDCurrency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//
//

import Foundation
import CoreData

extension CDCurrency {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDCurrency> {
        return NSFetchRequest<CDCurrency>(entityName: "CDCurrency")
    }

    @NSManaged public var buy: Double
    @NSManaged public var code: String
    @NSManaged public var country: String
    @NSManaged public var currency: String
    @NSManaged public var currencyPlural: String
    @NSManaged public var groupKey: Int16
    @NSManaged public var number: Int16
    @NSManaged public var sell: Double
    @NSManaged public var container: NSOrderedSet?
}

// MARK: Generated accessors for container
extension CDCurrency {
    @objc(insertObject:inContainerAtIndex:)
    @NSManaged public func insertIntoContainer(_ value: CDContainer, at idx: Int)

    @objc(removeObjectFromContainerAtIndex:)
    @NSManaged public func removeFromContainer(at idx: Int)

    @objc(insertContainer:atIndexes:)
    @NSManaged public func insertIntoContainer(_ values: [CDContainer], at indexes: NSIndexSet)

    @objc(removeContainerAtIndexes:)
    @NSManaged public func removeFromContainer(at indexes: NSIndexSet)

    @objc(replaceObjectInContainerAtIndex:withObject:)
    @NSManaged public func replaceContainer(at idx: Int, with value: CDContainer)

    @objc(replaceContainerAtIndexes:withContainer:)
    @NSManaged public func replaceContainer(at indexes: NSIndexSet, with values: [CDContainer])

    @objc(addContainerObject:)
    @NSManaged public func addToContainer(_ value: CDContainer)

    @objc(removeContainerObject:)
    @NSManaged public func removeFromContainer(_ value: CDContainer)

    @objc(addContainer:)
    @NSManaged public func addToContainer(_ values: NSOrderedSet)

    @objc(removeContainer:)
    @NSManaged public func removeFromContainer(_ values: NSOrderedSet)
}

extension CDCurrency: Identifiable {
}
