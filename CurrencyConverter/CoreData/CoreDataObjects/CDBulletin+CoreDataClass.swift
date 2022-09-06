//
//  CDBulletin+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//
//

import Foundation
import CoreData

public class CDBulletin: NSManagedObject {
    func convertToBulletin() -> Bulletin {
        let bulletin = Bulletin(
            from: self.bank,
            date: self.date)
        return bulletin
    }
}
