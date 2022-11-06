//
//  MockCoreDataStack.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 19.10.2022.
//

import Foundation
import CoreData

class MockCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        container.persistentStoreDescriptions[0].url =
        URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.storeContainer = container
    }
}
