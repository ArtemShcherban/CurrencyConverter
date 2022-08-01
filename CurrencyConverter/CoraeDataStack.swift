//
//  CoraeDataStack.swift
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
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deleteFromCoreData() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        let deleteFetch = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try storeContainer.viewContext.execute(deleteFetch)
        } catch let error as NSError {
            print(error)
        }
    }
}
