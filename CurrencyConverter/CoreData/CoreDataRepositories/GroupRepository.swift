//
//  GroupRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 30.08.2022.
//

import Foundation
import CoreData

protocol GroupDataRepository {
    var countOfGroups: Int { get }
    func create(_ group: Group)
    func group(by keys: [Int]) -> [Group]?
    func group(by names: [String]) -> [Group]?
}

class GroupRepository: GroupDataRepository {
    private let coreDataStack = CoreDataStack.shared
   
    var countOfGroups: Int {
        let groupCount = coreDataStack.fetchManagedObjectCount(managedObject: CDGroup.self)
        return groupCount
    }
    
    func create(_ group: Group) {
        coreDataStack.backgroundContext.performAndWait {
            let cdGroup = CDGroup(context: coreDataStack.backgroundContext)
            cdGroup.name = group.name
            cdGroup.key = Int16(group.key)
            cdGroup.visible = group.visible
            coreDataStack.synchronizeContexts()
        }
    }
    
    func group(by keys: [Int]) -> [Group]? {
        let predicates = createPredicate(predict: keys)
        let fetchRequest = createFetchRequest(predicate: predicates)
        return groups(from: fetchRequest)
    }
    
    func group(by names: [String]) -> [Group]? {
        let predicates = createPredicate(predict: names)
        let fetchRequest = createFetchRequest(predicate: predicates)
        return groups(from: fetchRequest)
    }
    
    private func groups(from fetchRequest: NSFetchRequest<CDGroup>) -> [Group]? {
        var groups: [Group] = []
        coreDataStack.backgroundContext.performAndWait {
            do {
                let cdGroups = try coreDataStack.backgroundContext.fetch(fetchRequest)
                cdGroups.forEach { groups.append($0.convertToGroup()) }
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return groups
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
        if let predict = predict as? [Int] {
            predict.forEach { groupKey in
                let predicate = NSPredicate(format: "%K == %D", #keyPath(CDGroup.key), groupKey)
                predicates.append(predicate)
            }
        } else if let predict = predict as? [String] {
            predict.forEach { groupName in
                let predicate = NSPredicate(format: "%K == %@", #keyPath(CDGroup.name), groupName)
                predicates.append(predicate)
            }
        }
        return predicates
    }
}
