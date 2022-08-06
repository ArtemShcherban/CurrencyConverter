//
//  Group+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//
//

import Foundation
import CoreData

extension Group {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var visible: Bool
    @NSManaged public var name: String
    @NSManaged public var key: Int16
}

extension Group: Identifiable {
}
