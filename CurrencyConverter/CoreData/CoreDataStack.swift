//
//  CoreDataStack.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.08.2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    static let modelName = "CurrencyConverter"
    
    static let model: NSManagedObjectModel = {
        guard
            let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSManagedObjectModel()
        }
        return model
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
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
    
    func erase(entityName: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteFetch = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try storeContainer.viewContext.execute(deleteFetch)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func eraseAll() {
        let entities = storeContainer.managedObjectModel.entities
        for entity in entities {
            guard let name = entity.name else { return }
            erase(entityName: name)
        }
    }
}
