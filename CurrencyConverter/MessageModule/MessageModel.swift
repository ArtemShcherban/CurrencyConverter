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
    weak var delegate: MessageModelDelegate?
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var converterModel = ConverterModel.shared
    
    func prepareMessage(for phoneNumber: String) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = createMessage()
            controller.recipients = [phoneNumber]
            if let delegate = delegate {
                controller.messageComposeDelegate = delegate
                delegate.message(controller: controller)
            }
        }
    }
    
    func createMessage() -> String {
        let currencies = resultDataSource.selectedCurrencies
        let amount = converterModel.amount
        guard
            let baseCurrency = resultDataSource.baseCurrency,
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
//            let sum = converterModel.doCalculation(for: currency)
//            let sumString = sum.decimalFormat()
//            let currencyName = (sum <= 2) ? currency.currency : currency.currencyPlural
//            if index != currencies.count - 1 {
//                let subString = "\(sumString) \(currencyName) or\n"
//                message += subString
//            } else {
//                let subString = "\(sumString) \(currencyName)."
//                message += subString
//            }
        }
        return message
    }
}
