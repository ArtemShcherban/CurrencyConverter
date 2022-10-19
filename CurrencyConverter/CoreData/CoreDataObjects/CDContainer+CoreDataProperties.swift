//
//  CDContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 12.10.2022.
//
//

import Foundation
import CoreData

extension CDContainer {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDContainer> {
        return NSFetchRequest<CDContainer>(entityName: "CDContainer")
    }

    @NSManaged public var currencyCodes: [String]
}

extension CDContainer: Identifiable {
}
