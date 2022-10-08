//
//  RatesModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import Foundation

protocol RatesModelDelegate: AnyObject {
    var exchangeRateModel: ExchangeRateModel { get }
    var baseCurrency: Currency? { get set }
    var selectedCurrencies: [Currency] { get set }
    func updateCurrentTableView()
}

final class RatesModel {
    private let currencyRepository = CurrencyRepository(CoreDataStack.shared)
    private let containerRepository = ContainerRepository(CoreDataStack.shared)
    private(set) lazy var containerName = String()
        
    weak var delegate: RatesModelDelegate?
    
    func defineContainerName(value: Bool) {
        containerName = value ? ContainerConstants.Name.rate : ContainerConstants.Name.converter
    }
    
    func fillDataSource() {
        guard
            var currencies = containerRepository.currencies(from: containerName),
            !currencies.isEmpty else {
            delegate?.selectedCurrencies = []
            return }
        
        setExchangeRateFor(currencies: &currencies)
        
        if containerName == ContainerConstants.Name.converter {
            delegate?.baseCurrency = currencies.removeFirst()
        }
        delegate?.selectedCurrencies = currencies
    }
    
    private func setExchangeRateFor(currencies: inout [Currency]) {
        if let delegate = delegate {
            currencies = currencies.map { currency in
                return delegate.exchangeRateModel.setExchangeRate(for: currency)
            }
        }
    }
    
    func add(currency: Currency) {
        containerRepository.update(container: containerName, with: currency)
    }
    
    func replaceCurrency(at row: Int, with currency: Currency) {
        containerRepository.replaceIn(container: containerName, at: row, with: currency)
    }
    
    func removeCell(at indexPath: IndexPath) {
        guard var currency = delegate?.selectedCurrencies[indexPath.row] else { return }
        currency.buy = 0.0
        currency.sell = 0.0
        currencyRepository.updateCurrencyRate(for: currency)
        containerRepository.removeFrom(container: containerName, currency: currency)
        fillDataSource()
    }
    
    func isMaxNumberOfRows() -> Bool {
        guard let delegate = delegate else {
            return true
        }
        switch containerName {
        case ContainerConstants.Name.rate:
            return delegate.selectedCurrencies.count <= 2
        case ContainerConstants.Name.converter:
            return delegate.selectedCurrencies.count <= 1
        default:
            return true
        }
    }
}
