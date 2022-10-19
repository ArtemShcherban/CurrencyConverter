//
//  MessageModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 23.08.2022.
//

import Foundation
import MessageUI

final class MessageModel {
    weak var delegate: MainViewController?
    
    func createMessage(with date: String) -> String {
        guard let delegate = delegate else {
            return String()
        }
        
        let currencies = delegate.selectedCurrencies
        let amount = delegate.exchangeService.converterModel.amount
        
        guard
            let baseCurrency = delegate.baseCurrency,
            !currencies.isEmpty else {
            return String()
        }
        let baseCurrencyName = amount <= 2 ? baseCurrency.currency : baseCurrency.currencyPlural
        var message = String()
        if delegate.exchangeService.converterModel.isSellAction {
            message = """
            At the exchange rate as of
            \(date),
            for \(amount.decimalFormattedString()) \(baseCurrencyName)
            you can buy\n
            """
        } else {
            message = """
            At the exchange rate as of
            \(date),
            To buy \(amount.decimalFormattedString()) \(baseCurrencyName)
            you need\n
            """
        }
        
        for (index, currency) in currencies.enumerated() {
            let sum = delegate.exchangeService.converterModel.doCalculation(for: currency)
            let sumString = sum.decimalFormattedString()
            let currencyName = sum <= 2 ? currency.currency : currency.currencyPlural
            if index != currencies.count - 1 {
                let subString = "\(sumString) \(currencyName) or\n"
                message += subString
            } else {
                let subString = "\(sumString) \(currencyName)."
                message += subString
            }
        }
        return message
    }
}
