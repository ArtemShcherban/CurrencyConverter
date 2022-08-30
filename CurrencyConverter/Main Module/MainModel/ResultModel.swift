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

final class ResultModel: FetchRequesting { // 🥸 RENAME
    static let shared = ResultModel()
 
    private lazy var resultDataSource = ResultDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
//    private lazy var converterModel = ConverterModel.shared
    private lazy var exchangeRateModel = ExchangeRateModel()
    
//    private lazy var coreDataStack = CoreDataStack.shared // 🥸
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
    
//    func fillDataSource() {
//        let result = performRequest(for: tableView)
//
//        if result.isEmpty {
//            dataSource.selectedCurrencies = []
//            return
//        }
//
//        guard
//            let container = result.first,
//            var currencies = container.currencies?.array as? [CurrencyOLD] else {
//            return
//        }
//        if tableView == TableViewCostants.Name.converter {
//            let baseCurrency = currencies.removeFirst()
//            exchangeRateModel.setExchangeRate(for: baseCurrency)
//            dataSource.baseCurrency = baseCurrency
//        }
//        dataSource.selectedCurrencies = currencies
//    }
    
    private func setupBaseCurrency(from currencies: inout [Currency]) {
        var baseCurrency = currencies.removeFirst()
        exchangeRateModel.setExchangeRate(for: &baseCurrency)
        resultDataSource.baseCurrency = baseCurrency
    }
    
    func add(currency: Currency) {
        currencyContainerManager.updateContainer(containerName, with: currency)
    }
    
//   👻 func addCell(with currency: CurrencyOLD) {
//        let result = performRequest(for: tableView)
//
//        if !result.isEmpty {
//            guard let container = result.first else { return }
//            container.addToCurrencies(currency)
//        } else {
//            guard let container = createCurrencyContainer() else { return }
//            container.addToCurrencies(currency)
//        }
//        coreDataStack.saveContext()
//    }
    
    func replaceCurrency(at row: Int, with currency: Currency) {
        currencyContainerManager.replaceCurrency(in: containerName, at: row, with: currency)
    }
    
//    func changeCell(at row: Int, with currency: CurrencyOLD) {
//        let result = performRequest(for: tableView)
//        guard
//            let container = result.first,
//            let currencies = container.currencies?.array as? [CurrencyOLD] else {
//            return
//        }
//        let replacedCurrency = currencies[row]
//        replacedCurrency.buy = 0
//        replacedCurrency.sell = 0
//        container.replaceCurrencies(at: row, with: currency)
//        coreDataStack.saveContext()
//    }
    
    func removeCell(at indexPath: IndexPath) {
        var currency = resultDataSource.selectedCurrencies[indexPath.row]
        currency.buy = 0.0
        currency.sell = 0.0
        currencyManager.updateCurrency(currency)
        currencyContainerManager.deleteCurrency(currency, from: containerName)
        fillDataSource()
    }
    
//    func removeCell(at indexPath: IndexPath) {
//        let result = performRequest(for: tableView)
//        guard
//            let container = result.first else {
//            return
//        }
//        let removedCurrency = dataSource.selectedCurrencies[indexPath.row]
//        removedCurrency.buy = 0
//        removedCurrency.sell = 0
//        container.removeFromCurrencies(removedCurrency)
//        coreDataStack.saveContext()
//        fillDataSource()
//    }
    
//    private func createCurrencyContainer() -> CDCurrencyContainer? {
//        switch tableView {
//        case ContainerConstants.Name.rate:
//            return RateCurrencyContainer(context: coreDataStack.managedContext)
//
//        case ContainerConstants.Name.converter:
//            return ConverterCurrencyContainer(context: coreDataStack.managedContext)
//        default:
//            return nil
//        }
//    }

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
