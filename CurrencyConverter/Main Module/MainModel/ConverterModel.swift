//
//  ConverterModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 16.08.2022.
//

import UIKit
import CoreData

class ConverterModel: FetchRequesting {
    static let shared = ConverterModel()
    
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var coreDataStack = CoreDataStack.shared
    
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
    
//    func createDefaultBaseCurrency() {
//        let containerFetchRequest: NSFetchRequest<ConverterCurrencyContainer> =
//        ConverterCurrencyContainer.fetchRequest()
//        guard
//            let result = try? coreDataStack.managedContext.fetch(containerFetchRequest),
//            result.isEmpty else {
//            return
//        }
//        
//        let container = ConverterCurrencyContainer(context: coreDataStack.managedContext)
//        
//        let currencyFetchRequest: NSFetchRequest<CurrencyOLD> = CurrencyOLD.fetchRequest()
//        let predicate = NSPredicate(format: "%K == %@", #keyPath(CurrencyOLD.code), AppConstants.defaultCurrency)
//        currencyFetchRequest.predicate = predicate
//        guard
//            let result = try? coreDataStack.managedContext.fetch(currencyFetchRequest),
//            let currency = result.first else {
//            return
//        }
        
//        container.addToCurrencies(currency)
//        coreDataStack.saveContext()
//    }
    
//    func createDefaultBaseCurrency() {
//        let containerFetchRequest: NSFetchRequest<ConverterCurrencyContainer> =
//        ConverterCurrencyContainer.fetchRequest()
//        guard
//            let result = try? coreDataStack.managedContext.fetch(containerFetchRequest),
//            result.isEmpty else {
//            return
//        }
//
//        let container = ConverterCurrencyContainer(context: coreDataStack.managedContext)
//
//        let currencyFetchRequest: NSFetchRequest<CurrencyOLD> = CurrencyOLD.fetchRequest()
//        let predicate = NSPredicate(format: "%K == %@", #keyPath(CurrencyOLD.code), AppConstants.defaultCurrency)
//        currencyFetchRequest.predicate = predicate
//        guard
//            let result = try? coreDataStack.managedContext.fetch(currencyFetchRequest),
//            let currency = result.first else {
//            return
//        }
//
////        container.addToCurrencies(currency)
//        coreDataStack.saveContext()
//    }
}
