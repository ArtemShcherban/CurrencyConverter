//
//  ResultModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import Foundation
import CoreData

protocol ResultModelDelegate: AnyObject {
    func resultsTableViewReloadData()
}

final class ResultModel { // 🥸 RENAME
    static let shared = ResultModel()
 
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    private lazy var exchangeRateModel = ExchangeRateModel()
    
    private let currencyManager = CurrencyManager()
    private let currencyContainerManager = CurrencyContainerManager()
    
    private lazy var containerName = String() { // 🥸 RENAME
        didSet {
            currencyListModel.containerName = containerName
        }
    }
    
    weak var delegate: ResultModelDelegate?
    
    func defineContainerName(value: Bool) {
        containerName = value ? ContainerConstants.Name.converter : ContainerConstants.Name.rate
    }
    
    func fillDataSource() {
        guard
            var currencies = currencyContainerManager.getCurrencyFromContainer(name: containerName),
                !currencies.isEmpty else {
            resultDataSource.selectedCurrencies = []
            return }
        
        if containerName == ContainerConstants.Name.converter {
            setupBaseCurrency(from: &currencies)
        }
        resultDataSource.selectedCurrencies = currencies
    }
    
    private func setupBaseCurrency(from currencies: inout [Currency]) {
        var baseCurrency = currencies.removeFirst()
        exchangeRateModel.setExchangeRate(for: &baseCurrency)
        resultDataSource.baseCurrency = baseCurrency
    }
    
    func add(currency: Currency) {
        currencyContainerManager.updateContainer(containerName, with: currency)
    }
    
    func replaceCurrency(at row: Int, with currency: Currency) {
        currencyContainerManager.replaceCurrency(in: containerName, at: row, with: currency)
    }
    
    func removeCell(at indexPath: IndexPath) {
        var currency = resultDataSource.selectedCurrencies[indexPath.row]
        currency.buy = 0.0
        currency.sell = 0.0
        currencyManager.updateCurrencyRate(currency)
        currencyContainerManager.deleteCurrency(currency, from: containerName)
        fillDataSource()
    }

    func isMaxNumberOfRows() -> Bool {
        switch containerName {
        case ContainerConstants.Name.rate:
            if resultDataSource.selectedCurrencies.count <= 4 {
                return false
            } else {
                return true
            }
        case ContainerConstants.Name.converter:
            if resultDataSource.selectedCurrencies.count <= 2 {
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }
}
