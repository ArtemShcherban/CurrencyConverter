//
//  MockCoreDataStack.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 19.10.2022.
//

import Foundation
import CoreData

final class MockCoreDataStack {
    static func create() -> CoreDataStack {
        let mockCoreData = MockCoreDataStack()
        return mockCoreData.stack
    }
    
    private lazy var stack: CoreDataStack = {
        let coreDataStack = CoreDataStack()
        let container = createContainer()
        coreDataStack.storeContainer = container
        return coreDataStack
    }()
    
    private func createContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(
            name: CoreDataStack.modelName,
            managedObjectModel: CoreDataStack.model
        )
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
}
