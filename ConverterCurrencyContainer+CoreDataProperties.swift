//
//  ConverterCurrencyContainer+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 11.08.2022.
//
//

import Foundation
import CoreData

extension ConverterCurrencyContainer {
    @nonobjc public
    class func fetchRequest() -> NSFetchRequest<ConverterCurrencyContainer> {
        return NSFetchRequest<ConverterCurrencyContainer>(entityName: "ConverterCurrencyContainer")
    }
}
