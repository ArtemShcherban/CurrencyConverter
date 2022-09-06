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

class MessageModel {
    static let shared = MessageModel()
    private lazy var ratesDataSource = RatesDataSource.shared
    private lazy var converterModel = ConverterModel.shared
    
    func createMessage() -> String {
        let currencies = ratesDataSource.selectedCurrencies
        let amount = converterModel.amount
        guard
            let baseCurrency = ratesDataSource.baseCurrency,
            !currencies.isEmpty else {
            return String()
        }
        let baseCurrencyName = amount <= 2 ? baseCurrency.currency : baseCurrency.currencyPlural
        var message = String()
        if converterModel.isSellAction {
            message = """
            For \(amount.decimalFormat()) \(baseCurrencyName)
            you can buy\n
            """
        } else {
            message = """
            To buy \(amount.decimalFormat()) \(baseCurrencyName)
            you need\n
            """
        }
        
        for (index, currency) in currencies.enumerated() {
            let sum = converterModel.doCalculation(for: currency)
            let sumString = sum.decimalFormat()
            let currencyName = (sum <= 2) ? currency.currency : currency.currencyPlural
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
