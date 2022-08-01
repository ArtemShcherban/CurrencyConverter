//
//  Currency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.08.2022.
//
//

import Foundation
import CoreData

extension Currency {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String?
    @NSManaged public var country: String?
    @NSManaged public var currency: String?
    @NSManaged public var number: Int16
}

extension Currency: Identifiable {
}
