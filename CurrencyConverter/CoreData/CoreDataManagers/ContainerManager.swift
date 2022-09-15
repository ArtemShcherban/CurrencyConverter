//
//  ContainerManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 28.08.2022.
//

import Foundation

struct ContainerManager {
    private let containerDataRepository = ContainerDataRepository()
    
    func getContainerCount() -> Int {
        containerDataRepository.getCount()
    }
    
    func createContainers() {
        containerDataRepository.create()
    }
    
    func getFromContainer(with name: String) -> [Currency]? {
        containerDataRepository.getFrom(container: name)
    }
    
    func fillInContainer(with name: String, andWith currency: Currency) {
        containerDataRepository.fillIn(container: name, with: currency)
    }
    
    func updateContainer(with name: String, andWith currency: Currency) {
        containerDataRepository.update(container: name, with: currency)
    }
    
    func replaceInContainer(with name: String, at row: Int, with currency: Currency) {
        containerDataRepository.replaceIn(container: name, at: row, with: currency)
    }
    
    func removeFromContainer(with name: String, currency: Currency) {
        containerDataRepository.removeFrom(container: name, currency: currency)
    }
}
