//
//  CDConverterContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//
//

import Foundation
import CoreData

extension CDConverterContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<CDConverterContainer> {
        return NSFetchRequest<CDConverterContainer>(entityName: "CDConverterContainer")
    }
}
