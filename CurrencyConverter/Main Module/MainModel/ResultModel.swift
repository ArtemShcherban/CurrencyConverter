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
    
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var dataSource = ResultDataSource.shared
    private lazy var currencyListModel = CurrencyListModel.shared
    
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
            let currencies = container.currencies?.array as? [Currency] else {
            return
        }
        dataSource.selectedCurrencies = currencies
    }
    
    func addCell(with currency: Currency) {
        let result = performRequest(for: tableView)
        
        if !result.isEmpty {
            guard let container = result.first else { return }
            container.addToCurrencies(currency)
        } else {
            guard let container = createCurrencyContainer() else { return }
            container.addToCurrencies(currency)
        }
        coreDataStack.saveContext()
    }
    
    func changeCell(at row: Int, with currency: Currency) {
        let replacedCurrency = dataSource.selectedCurrencies[row]
        replacedCurrency.buy = 0
        replacedCurrency.sell = 0
        replacedCurrency.totalAmount = 0
        let result = performRequest(for: tableView)
        guard let container = result.first else { return }
        container.replaceCurrencies(at: row, with: currency)
        coreDataStack.saveContext()
    }
    
    func removeCell(at indexPath: IndexPath) {
        let removedCurrency = dataSource.selectedCurrencies[indexPath.row]
        removedCurrency.buy = 0
        removedCurrency.sell = 0
        removedCurrency.totalAmount = 0
        let result = performRequest(for: tableView)
        guard let container = result.first else { return }
        container.removeFromCurrencies(at: indexPath.row)
        guard let currencies = container.currencies?.array as? [Currency] else { return }
        dataSource.selectedCurrencies = currencies
        coreDataStack.saveContext()
    }
    
//    func removeCell(at indexPath: IndexPath) {
//        let result = performRequest(for: tableView)
//        guard
//            let container = result.first,
//            let currencies = container.currencies?.array as? [Currency] else {
//            return
//        }
//        let removedCurrency = currencies[indexPath.row]
//        removedCurrency.buy = 0
//        removedCurrency.sell = 0
//        removedCurrency.totalAmount = 0
//        container.removeFromCurrencies(removedCurrency)
//        guard let currencies = container.currencies?.array as? [Currency] else { return }
//        dataSource.selectedCurrencies = currencies
//        coreDataStack.saveContext()
//    }
    
    private func createCurrencyContainer() -> CurrencyContainer? {
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
