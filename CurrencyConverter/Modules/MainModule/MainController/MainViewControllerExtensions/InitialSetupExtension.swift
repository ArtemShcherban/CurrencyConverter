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
    
    func initialSetup(complition: @escaping () -> Void) {
        exchangeService.delegate = self
        exchangeService.insertCurrencies()
        complition()
    }
    
    func executeOnFirstStartup() {
        if isFirstTimeLaunched {
            self.mainAsyncQueue?.dispatchAfter(
                deadline: .now() + .seconds(2)) {
                    self.exchangeRatesView.helpButtonPressed()
            }
            UserDefaults.standard.set(true, forKey: AppConstants.launchedBefore)
            return
        }
        return
    }
}
