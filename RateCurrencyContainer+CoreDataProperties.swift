//
//  RateCurrencyContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//
//

import Foundation
import CoreData

extension RateCurrencyContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<RateCurrencyContainer> {
        return NSFetchRequest<RateCurrencyContainer>(entityName: "RateCurrencyContainer")
    }
}
