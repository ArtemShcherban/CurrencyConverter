//
//  CDRateContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//
//

import Foundation
import CoreData

extension CDRateContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDRateContainer> {
        return NSFetchRequest<CDRateContainer>(entityName: "CDRateContainer")
    }
}
