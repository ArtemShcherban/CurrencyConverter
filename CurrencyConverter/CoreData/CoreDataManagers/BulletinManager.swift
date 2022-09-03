//
//  BulletinManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 01.09.2022.
//

import Foundation

struct BulletinManager {
    let bulletinDataRepository = BulletinDataRepository()
    
    func createBulletin(_ bulletin: Bulletin) {
        bulletinDataRepository.create(bulletin: bulletin)
    }
    
    func createExchangeRate(_ exchangeRate: ExchangeRate) {
        bulletinDataRepository.create(exchangeRate: exchangeRate)
    }
    
    func fetchBulletin(of date: Date) -> Bulletin? {
        bulletinDataRepository.get(by: date)
    }
    
    func saveExchangeRate(_ exchangeRate: ExchangeRate, _ date: Date) {
        bulletinDataRepository.handleSaving(exchangeRate: exchangeRate, date)
    }
    
//    func updateBulletin(of date: Date, _ exchangeRate: ExchangeRate) {
//        bulletinDataRepository.update(of: date, exchangeRate: exchangeRate)
//    }
}
