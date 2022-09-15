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
    
//    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
//        var results: [T]?
//        print("CoreDataStack fetchManagedObject ------ \(Thread.current) #1")
//        do {
//            let result = try managedContext.fetch(managedObject.fetchRequest()) as? [T]
//            let backResult = try backgroundContext.fetch(managedObject.fetchRequest()) as? [T]
//            results = result
//            //                    return result
//        } catch let nserror as NSError {
//            debugPrint(nserror)
//        }
//        let fetchRequest = managedObject.fetchRequest()
//        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] result in
//            guard let result = result.finalResult else { return }
//            guard let array = result as? [T] else { return }
//            results = array
//            print("CoreDataStack fetchManagedObject ------ \(Thread.current) #1")
//        }
//
//        do {
//            let backgroundContext = storeContainer.newBackgroundContext()
//            try backgroundContext.execute(asyncFetch)
//        } catch let nserror as NSError {
//            debugPrint(nserror)
//        }
//        return results
//    }
    
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
    
//    func save(_ backgroundContext: NSManagedObjectContext) {
//        guard backgroundContext.hasChanges else { return }
//        
//        do {
//            try backgroundContext.save()
//        } catch let error as NSError {
//            print("Unresolved error \(error), \(error.userInfo)")
//        }
//    }
    
    func saveBackgroundContext() {
        guard backgroundContext.hasChanges else { return }
        
        do {
            try backgroundContext.save()
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
