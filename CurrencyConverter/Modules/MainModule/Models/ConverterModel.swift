//
//  ConverterModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 16.08.2022.
//

import UIKit

final class ConverterModel {
    lazy var isSellAction = true
    lazy var amount: Double = 0.0
    
    func transform(_ text: String?) -> String {
        guard let text = text, !text.isEmpty else {
            self.amount = 0.0
            return String()
        }
        var noSpacesText = text.components(separatedBy: " ").joined()
        if noSpacesText.count >= 4 &&
            noSpacesText[noSpacesText.index(noSpacesText.endIndex, offsetBy: -4)] == "." {
            noSpacesText.removeLast()
        }
        
        guard
            let amount = Double(noSpacesText) else {
            return formatted(noSpacesText)
        }
        self.amount = amount
        
        return formatted(noSpacesText)
    }
    
    private func formatted(_ text: String) -> String {
        let amountAsString = amount.decimalFormattedString(0)
        if text.last == "." {
            return "\(amountAsString)."
        } else if text.suffix(2) == ".0" {
            return "\(amountAsString).0"
        } else if
            (text.count >= 3) &&
                (text[text.index(text.endIndex, offsetBy: -3)] == ".") &&
                (text.last == "0") {
            return "\(amountAsString)0"
        }
        
        return amountAsString
    }
    
    func doCalculation(for currency: Currency, with baseCurrency: Currency?) -> Double {
        guard let baseCurrency = baseCurrency else { return 0.00 }
        if isSellAction {
            return  currency.sell > 0 ? amount * baseCurrency.buy / currency.sell : 0.00
        } else {
            return  currency.buy > 0 ? amount * baseCurrency.sell / currency.buy : 0.00
        }
    }
}
