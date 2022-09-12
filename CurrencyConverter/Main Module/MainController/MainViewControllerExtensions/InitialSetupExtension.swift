//
//  InitialSetupExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController {
    var isFirstTimeLaunched: Bool {
        !UserDefaults.standard.bool(forKey: "launchedBefore")
    }
    
    private var initialModel: InitialModel {
        return InitialModel()
    }
    
    func initialSetup() {
        initialModel.insertCurrencies()
        initialModel.insertGroups()
        initialModel.createCurrencyContainers()
    }
    
    func executeOnFirstStartup() {
        if isFirstTimeLaunched {
            self.initialModel.updateContainersWithDefaultCurrencies()
            self.mainAsyncQueue?.dispatchAfter(
                deadline: .now() + .seconds(2)) {
                    self.mainView.guidelinesMessage()
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return
        }
        return
    }
}
