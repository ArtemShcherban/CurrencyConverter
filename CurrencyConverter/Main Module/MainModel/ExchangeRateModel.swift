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
    
    func createExchangeRates(monobankData: [MonoBankExchangeRate], _ updateDate: Date) {
        guard let bulletin = try? getBulettin() else { return }
        bulletin.date = updateDate
        
        monobankData.forEach { monoBankExchangeRate in
            if monoBankExchangeRate.currencyCodeB == 980 {
                let code = monoBankExchangeRate.currencyCodeA
                let rate = handle(monoBankExchangeRate)
                let exchangeRate = ExchangeRate(context: coreDataStack.managedContext)
                exchangeRate.bulletin = bulletin
                exchangeRate.number = Int16(code)
                exchangeRate.buy = rate.buy
                exchangeRate.sell = rate.sell
            }
        }
        coreDataStack.saveContext()
    }
    
    private func getBulettin() throws -> Bulletin {
        let fetchRequest: NSFetchRequest<Bulletin> = Bulletin.fetchRequest()
        
        guard let result = try? coreDataStack.managedContext.fetch(fetchRequest) else {
            throw CoreDataError.unresolved
        }
        if result.isEmpty {
            return Bulletin(context: coreDataStack.managedContext)
        }
        guard let bulletin = result.first else { throw CoreDataError.unresolved }
        return bulletin
    }
    
    private func handle(_ rate: MonoBankExchangeRate) -> (buy: Double, sell: Double) {
        if rate.buy == 0.0 || rate.sell == 0.0 {
            let calculatedRate = calculateFrom(rate.cross)
            return (calculatedRate.buy, calculatedRate.sell)
        } else {
            return (rate.buy, rate.sell)
        }
    }
    
    private func calculateFrom(_ rateCross: Double) -> (buy: Double, sell: Double) {
        let rateBuy = rateCross - rateCross * 0.05
        let rateSell = rateCross + rateCross * 0.05
        return (rateBuy, rateSell)
    }
    
    func setExchangeRate(for indexPath: IndexPath) {
        let currency = dataSource.selectedCurrencies[indexPath.row]
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        let predicate = NSPredicate(format: "%K == %D", #keyPath(ExchangeRate.number), currency.number)
        fetchRequest.predicate = predicate
        
        guard
            let result = try? coreDataStack.managedContext.fetch(fetchRequest),
            let exchangeRate = result.first else {
            return
        }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
}
