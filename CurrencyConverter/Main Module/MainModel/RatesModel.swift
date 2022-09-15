//
//  RatesModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import Foundation
import CoreData

protocol RatesModelDelegate: AnyObject {
    func updateCurrentTableView()
}

final class RatesModel {
    static let shared = RatesModel()
 
    private lazy var ratesDataSource = RatesDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    private lazy var exchangeRateModel = ExchangeRateModel.shared
    
    private let currencyManager = CurrencyManager()
    private let containerManager = ContainerManager()
    
    private lazy var containerName = String() {
        didSet {
            currencyListModel.containerName = containerName
        }
    }
        
    weak var delegate: RatesModelDelegate?
    
    func defineContainerName(value: Bool) {
        containerName = value ? ContainerConstants.Name.rate : ContainerConstants.Name.converter
    }
    
    func fillDataSource() {
        guard
            var currencies = containerManager.getFromContainer(with: containerName),
            !currencies.isEmpty else {
            ratesDataSource.selectedCurrencies = []
            return }
        
        setExchangeRateFor(currencies: &currencies)
        
        if containerName == ContainerConstants.Name.converter {
            ratesDataSource.baseCurrency = currencies.removeFirst()
        }
        ratesDataSource.selectedCurrencies = currencies
    }
        
    private func setExchangeRateFor(currencies: inout [Currency]) {
        currencies = currencies.map { currency in
            exchangeRateModel.setExchangeRate(for: currency)
        }
    }
    
    func add(currency: Currency) {
        containerManager.updateContainer(with: containerName, andWith: currency)
    }
    
    func replaceCurrency(at row: Int, with currency: Currency) {
        containerManager.replaceInContainer(with: containerName, at: row, with: currency)
    }
    
    func removeCell(at indexPath: IndexPath) {
        var currency = ratesDataSource.selectedCurrencies[indexPath.row]
        currency.buy = 0.0
        currency.sell = 0.0
        currencyManager.updateCurrencyRate(for: currency)
        containerManager.removeFromContainer(with: containerName, currency: currency)
        fillDataSource()
    }

    func isMaxNumberOfRows() -> Bool {
        switch containerName {
        case ContainerConstants.Name.rate:
            if ratesDataSource.selectedCurrencies.count <= 2 {
                return true
            } else {
                return false
            }
        case ContainerConstants.Name.converter:
            if ratesDataSource.selectedCurrencies.count <= 1 {
                return true
            } else {
                return false
            }
        default:
            return true
        }
    }
}
