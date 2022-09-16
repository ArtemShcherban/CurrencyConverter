//
//  CoreDataStack.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.08.2022.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack(modelName: "CurrencyConverter")
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func fetchManagedObjectCount<T: NSManagedObject>(managedObject: T.Type) -> Int {
        var resultCount = 0
        managedContext.performAndWait {
            do {
                resultCount = try managedContext.count(for: managedObject.fetchRequest())
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return resultCount
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        var result: [T]?
        managedContext.performAndWait {
            do {
                result = try managedContext.fetch(managedObject.fetchRequest()) as? [T]
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return result
    }
    
    func synchronizeContexts() {
        guard backgroundContext.hasChanges else { return }
        
        do {
            try backgroundContext.save()
            saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func saveContext() {
        managedContext.perform {
            guard self.managedContext.hasChanges else { return }
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteFromCoreData(entityName: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteFetch = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try storeContainer.viewContext.execute(deleteFetch)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteAllEntities() {
        let entities = storeContainer.managedObjectModel.entities
        for entity in entities {
            guard let name = entity.name else { return }
            deleteFromCoreData(entityName: name)
        }
    }
}
