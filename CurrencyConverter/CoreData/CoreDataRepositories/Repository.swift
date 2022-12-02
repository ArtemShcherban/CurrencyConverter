//
//  Repository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 08.10.2022.
//

import Foundation
import CoreData

class Repository {
    private(set) var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
