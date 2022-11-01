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
    private(set) var managedObjectContext: NSManagedObjectContext

    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        managedObjectContext = coreDataStack.managedContext
    }
    
    init(_ coreDataStack: CoreDataStack, managedObjectContext: NSManagedObjectContext) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
}
