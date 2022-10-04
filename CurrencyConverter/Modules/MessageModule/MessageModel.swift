//
//  MessageModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 23.08.2022.
//

import Foundation
import MessageUI

protocol MessageModelDelegate: MFMessageComposeViewControllerDelegate {
    func message(controller: MFMessageComposeViewController)
}

final class MessageModel {
    private lazy var mainDataSource = MainDataSource.shared
    private lazy var converterModel = ConverterModel.shared
    
    func createMessage(with date: String) -> String {
        let currencies = mainDataSource.selectedCurrencies
        let amount = converterModel.amount
        guard
            let baseCurrency = mainDataSource.baseCurrency,
            !currencies.isEmpty else {
            return String()
        }
        let baseCurrencyName = amount <= 2 ? baseCurrency.currency : baseCurrency.currencyPlural
        var message = String()
        if converterModel.isSellAction {
            message = """
            At the exchange rate as of
            \(date),
            for \(amount.decimalFormattedString()) \(baseCurrencyName)
            you can buy\n
            """
        } else {
            message = """
            To buy \(amount.decimalFormattedString()) \(baseCurrencyName)
            you need\n
            """
        }
        
        for (index, currency) in currencies.enumerated() {
            let sum = converterModel.doCalculation(for: currency)
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
