//
//  CDGroup+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//
//

import Foundation
import CoreData

extension CDGroup {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDGroup> {
        return NSFetchRequest<CDGroup>(entityName: "CDGroup")
    }

    @NSManaged public var visible: Bool
    @NSManaged public var name: String
    @NSManaged public var key: Int16
}

extension CDGroup: Identifiable {
}
