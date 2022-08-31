//
//  CDGroup+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 05.08.2022.
//
//

import Foundation
import CoreData

@objc(CDGroup)
public class CDGroup: NSManagedObject {
    func convertToGroup() -> Group {
        let group = Group(
            visible: self.visible,
            name: self.name,
            key: self.key)
        return group
    }
}
