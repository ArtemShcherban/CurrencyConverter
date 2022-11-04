//
//  XCTestCaseExtension.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 31.10.2022.
//

import XCTest
@testable import CurrencyConverter

extension XCTestCase {
    func createMockMainViewController(completion: @escaping (MainViewController) -> Void) {
        let coreDataStack = TestCoreDataStack()
        let mainViewController = MainViewController()
        mainViewController.exchangeService = ExchangeService(coreDataStack)
        mainViewController.exchangeService.delegate = mainViewController
        mainViewController.exchangeService.insertCurrencies()
        completion(mainViewController)
    }
    
    func setTestDefaultCurrenciesNumbers() {
        DefaultCurrencies.exRatesCurrenciesNumbers = MockCurrency.currencyNumbers
        DefaultCurrencies.converterCurrenciesNumbers = MockCurrency.currencyNumbers
    }
    
    func updateContainer(with containerName: String, in repository: ContainerRepository) {
        let currencies = MockCurrency.currencies
        
        currencies.forEach {
            repository.update(container: containerName, with: $0)
        }
    }
}
