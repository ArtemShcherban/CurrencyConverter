//
//  XCTestCaseExtension.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 31.10.2022.
//

import XCTest
@testable import CurrencyConverter

extension XCTestCase {
    func createMockMainViewController() -> MainViewController {
        ExchangeService.coreDataStack = MockCoreDataStack.create()
        let mainViewController = MainViewController()
        mainViewController.exchangeService.delegate = mainViewController
        mainViewController.exchangeService.insertCurrencies()
        return mainViewController
    }
    
    func setTestDefaultCurrenciesNumbers() {
        DefaultCurrencies.exRatesCurrenciesNumbers = MockCurrency.currencyNumbers
        DefaultCurrencies.converterCurrenciesNumbers = MockCurrency.currencyNumbers
    }
}
