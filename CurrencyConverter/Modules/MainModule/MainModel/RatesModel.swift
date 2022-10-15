//
//  RatesModel.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 06.08.2022.
//

import Foundation

protocol RatesModelDelegate: AnyObject {
    var currenciesList: [Currency] { get }
    var groups: [Group] { get }
    var mainModel: MainModel { get }
    var baseCurrency: Currency? { get set }
    var selectedCurrencies: [Currency] { get set }
    func updateCurrentTableView()
}

final class RatesModel {
    private let containerRepository = ContainerRepository(CoreDataStack.shared)
    private(set) lazy var containerName = String()
    
    weak var delegate: RatesModelDelegate?
    
    func defineContainerName(value: Bool) {
        containerName = value ? ContainerConstants.Name.rate : ContainerConstants.Name.converter
    }
    
    func fillSelectedCurrencies() {
        guard
            let codes = containerRepository.currencyCodes(from: containerName),
            !codes.isEmpty else {
            delegate?.selectedCurrencies = []
            return
        }
        
        var currencies: [Currency] = []
        for code in codes {
            guard let currency = delegate?.currenciesList.first(where: { $0.code == code }) else {
                continue
            }
            currencies.append(currency)
        }
        
        currencies = setExchangeRateFor(currencies: currencies)
        
        if containerName == ContainerConstants.Name.converter {
            delegate?.baseCurrency = currencies.removeFirst()
        }
        delegate?.selectedCurrencies = currencies
    }
    
    private func setExchangeRateFor(currencies: [Currency]) -> [Currency] {
        var currencies = currencies
        if let delegate = delegate {
            currencies = currencies.map { currency in
                return delegate.mainModel.exchangeRate.setExchangeRate(for: currency)
            }
        }
        return currencies
    }
    
    func add(currency: Currency) {
        containerRepository.update(container: containerName, with: currency)
    }
    
    func replaceCurrency(at row: Int, with currency: Currency) {
        containerRepository.replaceIn(container: containerName, at: row, with: currency)
    }
    
    func removeCell(at indexPath: IndexPath) {
        guard let currency = delegate?.selectedCurrencies[indexPath.row] else { return }
        containerRepository.removeFrom(container: containerName, currency: currency)
        fillSelectedCurrencies()
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
