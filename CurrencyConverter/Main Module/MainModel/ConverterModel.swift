//
//  ConverterModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 16.08.2022.
//

import UIKit

class ConverterModel {
    static let shared = ConverterModel()
    
    private lazy var resultDataSource = ResultDataSource.shared
    
    lazy var isSellAction = true
    lazy var amount: Double = 0.0
    
    func transform(_ text: String?) -> String {
        guard let text = text, !text.isEmpty else {
            self.amount = 0.0
            return String()
        }
        var noSpacesText = text.replacingOccurrences(of: " ", with: "")
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
    
    func formatted(_ text: String) -> String {
        let amountAsString = amount.decimalFormat(0)
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
    
    func doCalculation(for currency: Currency) -> Double {
        guard let baseCurrency = resultDataSource.baseCurrency else { return 0.00 }
        if isSellAction {
            return  currency.sell > 0 ? amount * baseCurrency.buy / currency.sell : 0.00
        } else {
            return  currency.buy > 0 ? amount * baseCurrency.sell / currency.buy : 0.00
        }
    }
}
