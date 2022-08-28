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

final class ResultModel: FetchRequesting {
    static let shared = ResultModel()
 
    private lazy var dataSource = ResultDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    private lazy var converterModel = ConverterModel.shared
    private lazy var exchangeRateModel = ExchangeRateModel()
    
    private lazy var coreDataStack = CoreDataStack.shared // 🥸
    private let currencyContainerManager = CurrencyContainerManager()
    
    private lazy var tableView = String() {
        didSet {
            currencyListModel.tableView = tableView
        }
    }
    
    weak var delegate: ResultModelDelegate?
    
    func defineTableViewName(value: Bool) {
        tableView = value ? TableViewCostants.Name.converter : TableViewCostants.Name.rate
    }
    
    func fillDataSource() {
        let result = performRequest(for: tableView)
        
        if result.isEmpty {
            dataSource.selectedCurrencies = []
            return
        }
        
        guard
            let container = result.first,
            var currencies = container.currencies?.array as? [CurrencyOLD] else {
            return
        }
        if tableView == TableViewCostants.Name.converter {
            let baseCurrency = currencies.removeFirst()
            exchangeRateModel.setExchangeRate(for: baseCurrency)
            dataSource.baseCurrency = baseCurrency
        }
        dataSource.selectedCurrencies = currencies
    }
    
    func add(currency: Currency) {
        currencyContainerManager.updateContainer(tableView, with: currency)
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
    
    func changeCell(at row: Int, with currency: CurrencyOLD) {
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
    }
    
    func removeCell(at indexPath: IndexPath) {
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
    }
    
    private func createCurrencyContainer() -> CDCurrencyContainer? {
        switch tableView {
        case TableViewCostants.Name.rate:
            return RateCurrencyContainer(context: coreDataStack.managedContext)
            
        case TableViewCostants.Name.converter:
            return ConverterCurrencyContainer(context: coreDataStack.managedContext)
        default:
            return nil
        }
    }

    func isMaxNumberOfRows() -> Bool {
        switch tableView {
        case TableViewCostants.Name.rate:
            if dataSource.selectedCurrencies.count <= 4 {
                return false
            } else {
                return true
            }
        case TableViewCostants.Name.converter:
            if dataSource.selectedCurrencies.count <= 2 {
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }
}
