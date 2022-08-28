//
//  LastUpdateDateManager.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 27.08.2022.
//

import Foundation

struct LastUpdateDateManager {
    private let lastUpdateDateDataRepository = LastUpdateDateDataRepository()
    
    func createLastUpdateDate(_ lastUpdateDate: Date) {
        lastUpdateDateDataRepository.create(lastUpdateDate: lastUpdateDate)
    }
    
    func fetchLastUdateDate() -> Date? {
        lastUpdateDateDataRepository.get()
    }
    
    func updateLastUpdateDate(with date: Date) {
        lastUpdateDateDataRepository.update(with: date)
    }
}
