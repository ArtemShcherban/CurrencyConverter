//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class ExchangeRateModel {
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var dataSource = ResultDataSource.shared
    
    private let exchangeRateManager = ExchangeRateManager()
    private let currencyManager = CurrencyManager()
    
    func createExchangeRate(bankData: [MonoBankExchangeRate]) {
        bankData.forEach { monoBankExchangeRate in
            if monoBankExchangeRate.currencyNumberB == 980 {
                let exchangeRate = ExchangeRate(from: monoBankExchangeRate)
                exchangeRateManager.createExchangeRate(exchangeRate)
            }
        }
    }
    
//    func createExchangeRate(bankData: [ExchangeRate], _ updateDate: Date) {
//        guard let bulletin = try? getBulettin() else { return }
//        bulletin.date = updateDate
//
//        bankData.forEach { monoBankExchangeRate in
//            if monoBankExchangeRate.currencyNumberB == 980 {
//                let code = monoBankExchangeRate.currencyNumberA
//                let rate = handle(monoBankExchangeRate)
//                let exchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
//                exchangeRate.bulletin = bulletin
//                exchangeRate.currencyNumber = Int16(code)
//                exchangeRate.buy = rate.buy
//                exchangeRate.sell = rate.sell
//            }
//        }
//        coreDataStack.saveContext()
//    }
    
//    private func getBulettin() throws -> Bulletin {
//        let fetchRequest: NSFetchRequest<Bulletin> = Bulletin.fetchRequest()
//        
//        guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else {
//            throw CoreDataError.unresolved
//        }
//        if result.isEmpty {
//            return Bulletin(context: coreDataStack.managedContext)
//        }
//        guard let bulletin = result.first else { throw CoreDataError.unresolved }
//        return bulletin
//    }
    
//    private func handle(_ rate: ExchangeRate) -> (buy: Double, sell: Double) {
//        if rate.buy == 0.0 || rate.sell == 0.0 {
//            let calculatedRate = calculateFrom(rate.cross)
//            return (calculatedRate.buy, calculatedRate.sell)
//        } else {
//            return (rate.buy, rate.sell)
//        }
//    }
//    
//    private func calculateFrom(_ rateCross: Double) -> (buy: Double, sell: Double) {
//        let rateBuy = rateCross - rateCross * 0.05
//        let rateSell = rateCross + rateCross * 0.05
//        return (rateBuy, rateSell)
//    }
    
    func setExchangeRate(for currency: inout Currency) {
        guard currency.code != "UAH" else {
            currency.buy = 1.0
            currency.sell = 1.0
            currencyManager.updateCurrency(currency)
            return
        }
        guard let exchangeRate = exchangeRateManager.fetchExchangeRate(by: currency.number) else { return }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        currencyManager.updateCurrency(currency)
    }
    
//    func setExchangeRate(for currency: Currency) {
//        guard currency.code != "UAH" else {
//            currency.buy = 1
//            currency.sell = 1
//            coreDataStack.saveContext()
//            return
//        }
//        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
//        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDExchangeRate.currencyNumber), currency.number)
//        fetchRequest.predicate = predicate
//
//        guard
//            let result = try? coreDataStack.managedContext.fetch(fetchRequest),
//            let exchangeRate = result.first else {
//            return
//        }
//        currency.buy = exchangeRate.buy
//        currency.sell = exchangeRate.sell
//        coreDataStack.saveContext()
//    }
}
