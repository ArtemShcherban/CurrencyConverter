//
//  InitialSetupExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.09.2022.
//

import Foundation

extension MainViewController {
    private var isFirstTimeLaunched: Bool {
        !UserDefaults.standard.bool(forKey: AppConstants.launchedBefore)
    }
    
    private var initialModel: InitialModel {
        let model = InitialModel()
        model.delegate = self
        return model
    }
    
    func initialSetup(complition: @escaping () -> Void) {
        initialModel.insertCurrencies {
            complition()
        }
    }
    
    func executeOnFirstStartup() {
        if isFirstTimeLaunched {
            self.mainAsyncQueue?.dispatchAfter(
                deadline: .now() + .seconds(2)) {
                    self.mainView.guidelinesMessage()
            }
            UserDefaults.standard.set(true, forKey: AppConstants.launchedBefore)
            return
        }
        return
    }
}
