//
//  ExchangeRate+CoreDataProperties.swift
//  
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

    @NSManaged public var rateBuy: Double
    @NSManaged public var rateSell: Double
    @NSManaged public var code: Int16
    @NSManaged public var bulletin: Bulletin?
}
