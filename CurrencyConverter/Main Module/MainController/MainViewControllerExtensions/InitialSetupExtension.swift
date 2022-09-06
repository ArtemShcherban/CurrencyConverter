//
//  InitialSetupExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController {
    private var initialModel: InitialModel {
        return InitialModel()
    }
    
    func initialSetup() {
        initialModel.insertCurrencies()
        initialModel.insertGroups()
        initialModel.createCurrencyContainers()
        initialModel.updateContainerWithBaseCurrency()
    }
}
