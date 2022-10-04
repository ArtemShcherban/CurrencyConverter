//
//  GroupManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 30.08.2022.
//

import Foundation

struct GroupManager {
    private let groupDataRepository = GroupDataRepository()
    
    func fetchGroupCount() -> Int {
        groupDataRepository.getCount
    }
    
    func createGroup(_ group: Group) {
        groupDataRepository.create(group: group)
    }
    
    func fetchGroups(by keys: [Int]) -> [Group]? {
        groupDataRepository.get(by: keys)
    }
    
    func fetchGroup(by groupNames: [String]) -> [Group]? {
        groupDataRepository.get(by: groupNames)
    }
}
