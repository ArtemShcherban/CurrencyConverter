//
//  ExchangeRate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 04.08.2022.
//
//

import Foundation
import CoreData

extension ExchangeRate {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<ExchangeRate> {
        return NSFetchRequest<ExchangeRate>(entityName: "ExchangeRate")
    }

    @NSManaged public var buy: Double
    @NSManaged public var sell: Double
    @NSManaged public var number: Int16
    @NSManaged public var bulletin: Bulletin?
}

extension ExchangeRate: Identifiable {
}
