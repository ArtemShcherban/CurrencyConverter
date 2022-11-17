//
//  ExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation
import CoreData

protocol ExchangeRateDataRepository {
    func create(bulletin: Bulletin)
    func checkBulletin(for date: Date) -> Bool
    func exchangeRate(for currency: Currency, on date: Date) -> ExchangeRate?
    func handleSaving(exchangeRate: ExchangeRate, on date: Date)
    func deleteBulletin(before date: Date)
}

final class ExchangeRateRepository: Repository, ExchangeRateDataRepository {
    func create(bulletin: Bulletin) {
        coreDataStack.backgroundContext.performAndWait {
            let cdBulletin = CDBulletin(context: coreDataStack.backgroundContext)
            cdBulletin.date = bulletin.date
            cdBulletin.bank = bulletin.bank
            cdBulletin.rates = []
            coreDataStack.synchronizeContexts()
        }
    }
    
    func checkBulletin(for date: Date) -> Bool {
        var bulletinExists = false
        coreDataStack.backgroundContext.performAndWait {
            if getCDBulletinID(for: date) != nil {
                bulletinExists = true
            }
        }
        return bulletinExists
    }
    
    func exchangeRate(for currency: Currency, on date: Date) -> ExchangeRate? {
        guard
            let cdBulletinID = getCDBulletinID(for: date),
            let cdExchangeRateID = getCDExchangeRateID(for: Int16(currency.number), and: cdBulletinID),
            let cdExchangeRate = coreDataStack.managedContext.object(with: cdExchangeRateID) as? CDExchangeRate
        else { return nil }
        
        return cdExchangeRate.convertToExchangeRate()
    }
    
    func handleSaving(exchangeRate: ExchangeRate, on date: Date) {
        coreDataStack.backgroundContext.performAndWait {
            guard let cdBulletinID = getCDBulletinID(for: date) else { return }
            guard let cdExchangeRateID = getCDExchangeRateID(for: Int16(exchangeRate.currencyNumber), and: cdBulletinID)
            else {
                createCD(exchangeRate: exchangeRate, in: cdBulletinID)
                return
            }
            update(cdExchangeRateID: cdExchangeRateID, with: exchangeRate)
        }
    }
    
    func deleteBulletin(before date: Date) {
        let predicate = NSPredicate(format: "%K < %@", #keyPath(CDBulletin.date), date as NSDate)
        let fetchRequest = fetchRequest(with: predicate)
        
        do {
            let cdBulletins = try self.coreDataStack.managedContext.fetch(fetchRequest)
            cdBulletins.forEach { cdBulletin in
                self.coreDataStack.managedContext.delete(cdBulletin)
            }
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
        coreDataStack.saveContext()
    }
    
    private func createCD(exchangeRate: ExchangeRate, in cdBulletinID: NSManagedObjectID) {
        guard let cdBulletin = coreDataStack.backgroundContext.object(with: cdBulletinID) as? CDBulletin else { return }
        
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.backgroundContext)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        cdExchangeRate.currencyNumber = Int16(exchangeRate.currencyNumber)
        cdExchangeRate.bulletin = cdBulletin
        coreDataStack.synchronizeContexts()
    }
    
    private func update(cdExchangeRateID: NSManagedObjectID, with exchangeRate: ExchangeRate) {
        coreDataStack.backgroundContext.performAndWait {
            guard let cdExchangeRate = coreDataStack.backgroundContext.object(with: cdExchangeRateID) as? CDExchangeRate
            else {
                return
            }
            cdExchangeRate.buy = exchangeRate.buy
            cdExchangeRate.sell = exchangeRate.sell
            coreDataStack.synchronizeContexts()
        }
    }
    
    private func getCDBulletinID(for date: Date) -> NSManagedObjectID? {
        let predicate = predicate(date: date)
        let fetchRequest = fetchRequest(with: predicate)
        var cdBulletinID: NSManagedObjectID?
        coreDataStack.managedContext.performAndWait {
            do {
                guard let objectID = try coreDataStack.managedContext.fetch(fetchRequest).first?.objectID
                else {
                    return
                }
                cdBulletinID = objectID
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        }
        return cdBulletinID
    }
    
    private func getCDExchangeRateID(
        for currencyNumber: Int16,
        and cdBulletinID: NSManagedObjectID
    ) -> NSManagedObjectID? {
        var cdExchangeRateID: NSManagedObjectID?
        
        coreDataStack.managedContext.performAndWait {
            guard
                let cdBulletin = coreDataStack.managedContext.object(with: cdBulletinID) as? CDBulletin,
                let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate],
                let objectID = cdExchangeRates.first(where: { cdExchangeRate in
                    cdExchangeRate.currencyNumber == currencyNumber
                })?.objectID else { return }
            
            cdExchangeRateID = objectID
        }
        return cdExchangeRateID
    }
    
    private func predicate(date: Date) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDBulletin.date), date as NSDate)
        return predicate
    }
    
    private func fetchRequest(with predicate: NSPredicate) -> NSFetchRequest<CDBulletin> {
        let fetchRequest: NSFetchRequest<CDBulletin> = CDBulletin.fetchRequest()
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
