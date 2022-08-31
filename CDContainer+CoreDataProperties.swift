//
//  CDContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//
//

import Foundation
import CoreData

extension CDContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDContainer> {
        return NSFetchRequest<CDContainer>(entityName: "CDContainer")
    }

    @NSManaged public var currencies: NSOrderedSet?
}

// MARK: Generated accessors for currencies
extension CDContainer {
    @objc(insertObject:inCurrenciesAtIndex:)
    @NSManaged public func insertIntoCurrencies(_ value: CDCurrency, at idx: Int)

    @objc(removeObjectFromCurrenciesAtIndex:)
    @NSManaged public func removeFromCurrencies(at idx: Int)

    @objc(insertCurrencies:atIndexes:)
    @NSManaged public func insertIntoCurrencies(_ values: [CDCurrency], at indexes: NSIndexSet)

    @objc(removeCurrenciesAtIndexes:)
    @NSManaged public func removeFromCurrencies(at indexes: NSIndexSet)

    @objc(replaceObjectInCurrenciesAtIndex:withObject:)
    @NSManaged public func replaceCurrencies(at idx: Int, with value: CDCurrency)

    @objc(replaceCurrenciesAtIndexes:withCurrencies:)
    @NSManaged public func replaceCurrencies(at indexes: NSIndexSet, with values: [CDCurrency])

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: CDCurrency)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: CDCurrency)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSOrderedSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSOrderedSet)
}

extension CDContainer: Identifiable {
}
