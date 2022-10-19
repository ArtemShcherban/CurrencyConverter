//
//  Repository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 08.10.2022.
//

import Foundation

class Repository {
    private(set) var coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
