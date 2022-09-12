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
        do {
            let resultCount = try managedContext.count(for: managedObject.fetchRequest())
            return resultCount
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return 0
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            let result = try managedContext.fetch(managedObject.fetchRequest()) as? [T]
            return result
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
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
