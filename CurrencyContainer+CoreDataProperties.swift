//
//  CurrencyContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//
//

import Foundation
import CoreData

extension CurrencyContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CurrencyContainer> {
        return NSFetchRequest<CurrencyContainer>(entityName: "CurrencyContainer")
    }

    @NSManaged public var currencies: NSOrderedSet?
}

// MARK: Generated accessors for currencies
extension CurrencyContainer {
    @objc(insertObject:inCurrenciesAtIndex:)
    @NSManaged public func insertIntoCurrencies(_ value: Currency, at idx: Int)

    @objc(removeObjectFromCurrenciesAtIndex:)
    @NSManaged public func removeFromCurrencies(at idx: Int)

    @objc(insertCurrencies:atIndexes:)
    @NSManaged public func insertIntoCurrencies(_ values: [Currency], at indexes: NSIndexSet)

    @objc(removeCurrenciesAtIndexes:)
    @NSManaged public func removeFromCurrencies(at indexes: NSIndexSet)

    @objc(replaceObjectInCurrenciesAtIndex:withObject:)
    @NSManaged public func replaceCurrencies(at idx: Int, with value: Currency)

    @objc(replaceCurrenciesAtIndexes:withCurrencies:)
    @NSManaged public func replaceCurrencies(at indexes: NSIndexSet, with values: [Currency])

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: Currency)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: Currency)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSOrderedSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSOrderedSet)
}

extension CurrencyContainer: Identifiable {
}
