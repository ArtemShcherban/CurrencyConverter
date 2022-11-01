//
//  XCTestCaseExtension.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 31.10.2022.
//

import XCTest
@testable import CurrencyConverter

extension XCTestCase {
    func prepareMockMainViewController(completion: @escaping (MainViewController) -> Void) {
        let mainViewController = MainViewController()
        mainViewController.exchangeService = ExchangeService()
        mainViewController.exchangeService.delegate = mainViewController
        mainViewController.exchangeService.insertCurrencies()
        completion(mainViewController)
    }
    
    func updateContainer(with containerName: String, in repository: ContainerRepository) {
        let currencies = MockCurrency.currencies
        
        currencies.forEach {
            repository.update(container: containerName, with: $0)
        }
    }
}
