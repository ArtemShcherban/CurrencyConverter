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
    
    var lastUpdateDate: Date? {
        lastUpdateDateDataRepository.date
    }
    
    func updateLastUpdateDate(with date: Date) {
        lastUpdateDateDataRepository.update(with: date)
    }
}
