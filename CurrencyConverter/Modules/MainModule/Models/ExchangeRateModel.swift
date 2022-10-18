//
//  ConverterMainModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 24.07.2022.
//

import Foundation
import CoreData

final class ExchangeRateModel {
    lazy var selectedDate = Date().startOfDay
    private let networkService = NetworkService()
    private let exchangeRateRepository = ExchangeRateRepository(CoreDataStack.shared)
    private var currencyList: [Currency]
    
    init(with currencyList: [Currency]) {
        self.currencyList = currencyList
    }
    
    func exchangeRates(for date: Date, completion: @escaping (Result<Date, NetworkServiceError> ) -> Void) {
        networkService.loadData(for: .monoBank) { result in
            self.handleResult(result, date) {
                completion($0)
            }
            self.networkService.loadData(for: .privatBank(with: date)) { result in
                self.handleResult(result, date) {
                    completion($0)
                }
            }
        }
    }
    
    private func handleResult<BankRate>(
        _ result: Result<[BankRate], NetworkServiceError>,
        _ date: Date,
        completion: @escaping (Result<Date, NetworkServiceError> ) -> Void
    ) {
        switch result {
        case .failure(let error):
            debugPrint(error)
            completion(.failure(error))
        case .success(let rates):
            let exchangeRates = convertToExchangeRates(bankRates: rates)
            updateBulletin(for: date, bankData: exchangeRates)
            completion(.success(date))
        }
    }
    
    private func convertToExchangeRates<T>(bankRates: [T]) -> [ExchangeRate] {
        var exchangeRates: [ExchangeRate] = []
        if let privatExchangeRates = bankRates as? [PrivatBankExchangeRate] {
            privatExchangeRates.forEach {
                exchangeRates.append( $0.convertToExchangeRate(currencyList: currencyList))
            }
        }
        if let monoExchangeRates = bankRates as? [MonoBankExchangeRate] {
            monoExchangeRates.forEach {
                exchangeRates.append( $0.convertToExchangeRate())
            }
        }
        return exchangeRates
    }
    
    func isBulletinInDatabase(for date: Date) -> Bool {
        return exchangeRateRepository.checkBulletin(for: date.startOfDay)
    }
    
    func updateBulletin(for date: Date, bankData: [ExchangeRate]) {
        if !isBulletinInDatabase(for: date.startOfDay) {
            exchangeRateRepository.create(bulletin: Bulletin(
                from: "\(date.yyyyMMdd) \(TitleConstants.bankName)",
                date: date.startOfDay))
        }
        updateExchangeRates(of: date.startOfDay, with: bankData)
    }
    
    private func updateExchangeRates(of date: Date, with bankData: [ExchangeRate]) {
        bankData.forEach { exchangeRate in
            if exchangeRate.currencyNumber != 0 {
                exchangeRateRepository.handleSaving(exchangeRate: exchangeRate, on: date.startOfDay)
            }
        }
    }
    
    func setExchangeRate(for currency: Currency) -> Currency {
        var currency = currency
        guard currency.code != "UAH" else {
            currency.buy = 1.0
            currency.sell = 1.0
            return currency
        }
        guard
            let exchangeRate = exchangeRateRepository.exchangeRate(for: currency, on: selectedDate) else {
            return currency
        }
        currency.buy = exchangeRate.buy
        currency.sell = exchangeRate.sell
        return currency
    }
    
    func removeOldExchangeRates() {
        exchangeRateRepository.deleteBulletin(before: Date().oneYearAgo)
    }
}
