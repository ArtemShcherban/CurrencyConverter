//
//  ExchangeRatesViewDelegateExtension.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 09.09.2022.
//

import Foundation

extension MainViewController: ExchangeRatesViewDelegate {
    func helpButtonPressed(completion: @escaping () -> Void) {
        guidelinesMessage {
            completion()
        }
    }
}
