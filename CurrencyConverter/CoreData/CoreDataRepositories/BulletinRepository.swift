//
//  BulletinRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation
import CoreData

protocol BulletinRepository {
    func create(bulletin: Bulletin)
    func get(by date: Date) -> Bulletin?
}

protocol ExchangeRateRepositoryPROTO {
    func create(exchangeRate: ExchangeRate)
    func getAll() -> [ExchangeRate]?
    //        func get(byCurrency number: Int16) -> ExchangeRate?
    //        func deleteExchangeRates()
}

struct BulletinDataRepository: BulletinRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func create(bulletin: Bulletin) {
        let cdBulletin = CDBulletin(context: coreDataStack.managedContext)
        cdBulletin.date = bulletin.date
        cdBulletin.bank = bulletin.bank
        cdBulletin.rates = []
        coreDataStack.saveContext()
    }
    
    func get(by date: Date) -> Bulletin? {
        let predicate = predicate(date: date)
        let fetchRequest = fetchRequest(with: predicate)
        guard let cdBulletin = runRequest(fetchRequest: fetchRequest) else { return nil }
        return cdBulletin.convertToBulletin()
    }
    
    func handleSaving(exchangeRate: ExchangeRate, _ date: Date) {
        if let cdBulletin = getCDBulletin(of: date) {
            guard
                let cdEcxhangeRates = (cdBulletin.rates.array as? [CDExchangeRate]),
                let cdExchangeRate = cdEcxhangeRates.first(where: { $0.currencyNumber == exchangeRate.currencyNumber }) else {
                createCD(exchangeRate: exchangeRate, in: cdBulletin)
                return
            }
            update(cdExchangeRate: cdExchangeRate, with: exchangeRate)
            return
        }
        print("Enable to handle saving the \(exchangeRate)")
    }
    
    func createCD(exchangeRate: ExchangeRate, in bulletin: CDBulletin) {
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        cdExchangeRate.bulletin = bulletin
        cdExchangeRate.currencyNumber = exchangeRate.currencyNumber
        coreDataStack.saveContext()
    }
    
    func update(cdExchangeRate: CDExchangeRate, with exchangeRate: ExchangeRate) {
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
    
    private func getCDExchangeRate(by number: Int16, _ date: Date) -> CDExchangeRate? {
        let predicate = predicate(date: date)
        let fetchRequest = fetchRequest(with: predicate)
        do {
            guard
                let cdBulletin = try coreDataStack.managedContext.fetch(fetchRequest).first,
                let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate],
                let cdExchangeRate = cdExchangeRates.first else {
                return nil
            }
            return cdExchangeRate
        } catch let error as NSError {
            debugPrint(error)
        }
        return nil
    }
    
    private func getCDBulletin(of date: Date) -> CDBulletin? {
        let predicate = predicate(date: date)
        let fetchRequest = fetchRequest(with: predicate)
        do {
            let cdBulletin = try coreDataStack.managedContext.fetch(fetchRequest).first
            return cdBulletin
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
    
    private func predicate(currencyNumber: Int16) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == %D", #keyPath(CDExchangeRate.currencyNumber), currencyNumber)
        return predicate
    }
    
    private func predicate(date: Date) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDBulletin.date), date as NSDate)
        return predicate
    }
    
    private func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<CDExchangeRate> {
        let fetchRequest: NSFetchRequest<CDExchangeRate> = CDExchangeRate.fetchRequest()
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    private func fetchRequest(with predicate: NSPredicate) -> NSFetchRequest<CDBulletin> {
        let fetchRequest: NSFetchRequest<CDBulletin> = CDBulletin.fetchRequest()
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    private func runRequest(fetchRequest: NSFetchRequest<CDBulletin>) -> CDBulletin? {
        do {
            let cdBulletin = try coreDataStack.managedContext.fetch(fetchRequest).first
            return cdBulletin
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        return nil
    }
}

extension BulletinDataRepository: ExchangeRateRepositoryPROTO {
    func create(exchangeRate: ExchangeRate) {
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
        cdExchangeRate.currencyNumber = Int16(exchangeRate.currencyNumber)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
    
    func getAll() -> [ExchangeRate]? {
        return nil
    }
}
