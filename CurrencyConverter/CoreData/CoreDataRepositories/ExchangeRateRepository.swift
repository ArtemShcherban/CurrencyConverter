//
//  ExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation
import CoreData

protocol ExchangeRateRepository {
    func create(bulletin: Bulletin)
    func checkBulletin(for date: Date) -> Bool
    func getExchangeRate(for currency: Currency, on date: Date) -> ExchangeRate?
    func handleSaving(exchangeRate: ExchangeRate, on date: Date)
    func deleteBulletinAndRates(before date: Date)
}

struct ExchangeRateDataRepository: ExchangeRateRepository {
    private let coreDataStack = CoreDataStack.shared
    
    func create(bulletin: Bulletin) {
        coreDataStack.managedContext.perform {
            let cdBulletin = CDBulletin(context: coreDataStack.managedContext)
            cdBulletin.date = bulletin.date
            cdBulletin.bank = bulletin.bank
            cdBulletin.rates = []
            coreDataStack.saveContext()
        }
    }
    
    func checkBulletin(for date: Date) -> Bool {
        var bulletinExists = false
        coreDataStack.managedContext.perform {
            if getCDBulletinID(for: date) != nil {
                bulletinExists = true
            }
        }
        return bulletinExists
    }
    
//    func checkBulletin(for date: Date) -> Bool {
//        let predicate = predicate(date: date)
//        let fetchRequest = fetchRequest(with: predicate)
//
//        guard runRequest(fetchRequest: fetchRequest) != nil else { return false }
//        return true
//    }
    
    func getExchangeRate(for currency: Currency, on date: Date) -> ExchangeRate? {
        guard
            let cdBulletinID = getCDBulletinID(for: date),
            let cdExchangeRateID = getCDExchangeRateID(for: currency.number, and: cdBulletinID),
            let cdExchangeRate = coreDataStack.managedContext.object(with: cdExchangeRateID) as? CDExchangeRate
        else { return nil }
        
        return cdExchangeRate.convertToExchangeRate()
    }
    
//    func getExchangeRate(for currency: Currency, on date: Date) -> ExchangeRate? {
//        guard
//            let cdBulletin = getCDBulletin(of: date),
//            let cdExchangeRate = getCDExchangeRate(for: currency.number, from: cdBulletin) else {
//            return nil
//        }
//        return cdExchangeRate.convertToExchangeRate()
//    }
    
    func handleSaving(exchangeRate: ExchangeRate, on date: Date) {
        coreDataStack.managedContext.perform {
            guard let cdBulletinID = getCDBulletinID(for: date),
            let cdBulletin = coreDataStack.managedContext.object(with: cdBulletinID) as? CDBulletin else {
                print("Unable to handle saving the \(exchangeRate)")
                return
            }
            guard
                let cdExchangeRateID = getCDExchangeRateID(for: exchangeRate.currencyNumber, and: cdBulletinID)
            else {
                createCD(exchangeRate: exchangeRate, in: cdBulletin)
                return
            }
            update(cdExchangeRateID: cdExchangeRateID, with: exchangeRate)
            return
        }
    }
    
//    func handleSaving(exchangeRate: ExchangeRate, on date: Date) {
//        guard let cdBulletin = getCDBulletin(of: date) else {
//            print("Unable to handle saving the \(exchangeRate)")
//            return
//        }
//        coreDataStack.managedContext.perform {
//            guard
//                let cdExchangeRate = getCDExchangeRate(for: exchangeRate.currencyNumber, from: cdBulletin) else {
//                createCD(exchangeRate: exchangeRate, in: cdBulletin)
//                return
//            }
//            update(cdExchangeRate: cdExchangeRate, with: exchangeRate)
//            return
//        }
//    }
    
    func deleteBulletinAndRates(before date: Date) {
        let predicate = NSPredicate(format: "%K < %@", #keyPath(CDBulletin.date), date as NSDate)
        let fetchRequest = fetchRequest(with: predicate)
        
        do {
            let cdBulletins = try coreDataStack.managedContext.fetch(fetchRequest)
            cdBulletins.forEach { cdBulletin in
                guard let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate] else { return }
                cdExchangeRates.forEach { cdExchangeRate in
                    coreDataStack.managedContext.delete(cdExchangeRate)
                }
                coreDataStack.managedContext.delete(cdBulletin)
                coreDataStack.saveContext()
            }
        } catch let nserror as NSError {
            debugPrint(nserror)
        }
    }
    
    private func createCD(exchangeRate: ExchangeRate, in bulletin: CDBulletin) {
        let cdExchangeRate = CDExchangeRate(context: coreDataStack.managedContext)
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        cdExchangeRate.bulletin = bulletin
        cdExchangeRate.currencyNumber = exchangeRate.currencyNumber
        coreDataStack.saveContext()
    }
    
    private func update(cdExchangeRateID: NSManagedObjectID, with exchangeRate: ExchangeRate) {
        guard let cdExchangeRate = coreDataStack.managedContext.object(with: cdExchangeRateID) as? CDExchangeRate
        else {
            return
        }
        cdExchangeRate.buy = exchangeRate.buy
        cdExchangeRate.sell = exchangeRate.sell
        coreDataStack.saveContext()
    }
    
//    private func update(cdExchangeRate: CDExchangeRate, with exchangeRate: ExchangeRate) {
//        cdExchangeRate.buy = exchangeRate.buy
//        cdExchangeRate.sell = exchangeRate.sell
//        coreDataStack.saveContext()
//    }
    
    private func getCDBulletinID(for date: Date) -> NSManagedObjectID? {
        let predicate = predicate(date: date)
        let fetchRequest = fetchRequest(with: predicate)
        var cdBulletinID: NSManagedObjectID?
            do {
                guard let objectID = try coreDataStack.managedContext.fetch(fetchRequest).first?.objectID
                else {
                    return nil
                }
                cdBulletinID = objectID
            } catch let nserror as NSError {
                debugPrint(nserror)
            }
        return cdBulletinID
    }
    
//    private func getCDBulletin(of date: Date) -> CDBulletin? {
//        let predicate = predicate(date: date)
//        let fetchRequest = fetchRequest(with: predicate)
//        let cdBulletin = runRequest(fetchRequest: fetchRequest)
//        return cdBulletin
//    }
    
    private func getCDExchangeRateID(
        for currencyNumber: Int16,
        and cdBulletinID: NSManagedObjectID
    ) -> NSManagedObjectID? {
        var cdExchangeRateID: NSManagedObjectID?
        
        guard
            let cdBulletin = coreDataStack.managedContext.object(with: cdBulletinID) as? CDBulletin,
            let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate],
            let objectID = cdExchangeRates.first(where: { cdExchangeRate in
                cdExchangeRate.currencyNumber == currencyNumber
            })?.objectID else { return nil }
        
        cdExchangeRateID = objectID
        
        return cdExchangeRateID
        }

//    private func getCDExchangeRate(for currencyNumber: Int16, from cdBulletin: CDBulletin) -> CDExchangeRate? {
//        guard
//            let cdExchangeRates = cdBulletin.rates.array as? [CDExchangeRate],
//            let cdExchangeRate = cdExchangeRates.first(where: { cdExchangeRate in
//                cdExchangeRate.currencyNumber == currencyNumber
//            }) else {
//            return nil
//        }
//        return cdExchangeRate
//    }
    
    private func predicate(date: Date) -> NSPredicate {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDBulletin.date), date as NSDate)
        return predicate
    }
    
    private func fetchRequest(with predicate: NSPredicate) -> NSFetchRequest<CDBulletin> {
        let fetchRequest: NSFetchRequest<CDBulletin> = CDBulletin.fetchRequest()
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
//    private func runRequest(fetchRequest: NSFetchRequest<CDBulletin>) -> CDBulletin? {
//        var cdBulletin: CDBulletin?
//        coreDataStack.managedContext.performAndWait {
//            do {
//                let cdBulletins = try coreDataStack.managedContext.fetch(fetchRequest)
//                cdBulletin = cdBulletins.first
//            } catch let nserror as NSError {
//                print(nserror)
//            }
//        }
//        return cdBulletin
//    }
}

//    func deleteCDBulletinAndRates(for date: Date) {
//        let predicate = predicate(date: date)
//        let fetchRequest = fetchRequest(with: predicate)
//
//        if let cdBulletin = runRequest(fetchRequest: fetchRequest),
//           let cdExchangesRates = cdBulletin.rates.array as? [CDExchangeRate] {
//            cdExchangesRates.forEach { cdExchangeRate in
//                coreDataStack.managedContext.delete(cdExchangeRate)
//                coreDataStack.saveContext()
//            }
//            coreDataStack.managedContext.delete(cdBulletin)
//            coreDataStack.saveContext()
//        }
//    }
    //
    //    func updateCDBulletinName() {
    //        guard let cdBulletins = coreDataStack.fetchManagedObject(managedObject: CDBulletin.self) else { return }
    //        cdBulletins.forEach { cdBulletin in
    //            cdBulletin.bank = "\(cdBulletin.date.yyyyMMdd) MonoBank&PrivatBank"
    //            coreDataStack.saveContext()
    //        }
    //    }
        
    //    func deleteCDExchangeRatesWithNullBulletin() {
    //        var index = 0
    //        let cdExchangeRates = coreDataStack.fetchManagedObject(managedObject: CDExchangeRate.self)
    //        cdExchangeRates?.forEach({ cdExchangeRate in
    //            print(cdExchangeRate.bulletin.rates.count)
    //            if cdExchangeRate.bulletin.rates.array.isEmpty {
    //                index += 1
    //                coreDataStack.managedContext.delete(cdExchangeRate)
    //                coreDataStack.saveContext()
    //                print(index)
    //            }
    //        })
    //    }
