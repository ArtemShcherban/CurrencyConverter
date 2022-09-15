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
    
    func initialSetup(complition: @escaping () -> Void) {
        initialModel.insertCurrencies {
            print("initialSetup ---- \(Thread.current)")
                self.initialModel.insertGroups()
                self.initialModel.createContainers()
                print("---------1--------")
                complition()
            print("---------2--------")
        }
        print("---------3--------")
    }
    
//    func initialSetup() {
//        initialModel.insertCurrencies()
//        initialModel.insertGroups()
//        initialModel.createCurrencyContainers()
//    }
    
    func executeOnFirstStartup() {
        if isFirstTimeLaunched {
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
