//
//  GroupRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 30.08.2022.
//

import Foundation
import CoreData

protocol GroupRepository {
    func getCount() -> Int
    func create(group: Group)
    func get(by keys: [Int16]) -> [Group]?
    func get(by names: [String]) -> [Group]?
}

struct GroupDataRepository: GroupRepository {
    private let coreDataStack = CoreDataStack.shared
   
    func getCount() -> Int {
        let groupCount = coreDataStack.fetchManagedObjectCount(managedObgect: CDGroup.self)
        return groupCount
    }
    
    func create(group: Group) {
        let cdGroup = CDGroup(context: coreDataStack.managedContext)
        cdGroup.name = group.name
        cdGroup.key = group.key
        cdGroup.visible = group.visible
        coreDataStack.saveContext()
    }
    
    func get(by keys: [Int16]) -> [Group]? {
        let predicates = createPredicate(predict: keys)
        let fetchRequest = createFetchRequest(predicate: predicates)
        return getGroups(from: fetchRequest)
    }
    
    func get(by names: [String]) -> [Group]? {
        let predicates = createPredicate(predict: names)
        let fetchRequest = createFetchRequest(predicate: predicates)
        return getGroups(from: fetchRequest)
    }
    
    private func getGroups(from fetchRequest: NSFetchRequest<CDGroup>) -> [Group]? {
        var groups: [Group] = []
        do {
            let cdGroups = try coreDataStack.managedContext.fetch(fetchRequest)
            cdGroups.forEach { groups.append($0.convertToGroup()) }
            return groups
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
    
    private func createFetchRequest(predicate: [NSPredicate]) -> NSFetchRequest<CDGroup> {
        let fetchRequest: NSFetchRequest<CDGroup> = CDGroup.fetchRequest()
        let compaundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicate)
        let keySortDescription = NSSortDescriptor(key: #keyPath(CDGroup.key), ascending: true)
        fetchRequest.predicate = compaundPredicate
        fetchRequest.sortDescriptors = [keySortDescription]
        return fetchRequest
    }
    
    private func createPredicate<T: Predictable>(predict: [T]) -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        if let predict = predict as? [Int16] {
            predict.forEach { groupKey in
                let predicate = NSPredicate(format: "%K == %D", #keyPath(CDGroup.key), groupKey)
                predicates.append(predicate)
            }
            return predicates
        } else if let predict = predict as? [String] {
            predict.forEach { groupName in
                let predicate = NSPredicate(format: "%K == %@", #keyPath(CDGroup.name), groupName)
                predicates.append(predicate)
            }
            return predicates
        }
        return []
    }
}

protocol Predictable {}
extension Int16: Predictable {}
extension String: Predictable {}
