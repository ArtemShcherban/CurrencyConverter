//
//  CDLastUpdateDate+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//
//

import Foundation
import CoreData

extension CDLastUpdateDate {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDLastUpdateDate> {
        return NSFetchRequest<CDLastUpdateDate>(entityName: "CDLastUpdateDate")
    }

    @NSManaged public var date: Date
}

extension CDLastUpdateDate: Identifiable {
}
