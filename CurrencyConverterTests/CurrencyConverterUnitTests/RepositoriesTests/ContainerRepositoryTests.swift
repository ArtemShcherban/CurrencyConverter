//
//  ContainerRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 20.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class ContainerRepositoryTests: XCTestCase {
    private var containerRepository: ContainerRepository!
    private let exRateContainer = ContainerName.exchangeRates
    private let converterContainer = ContainerName.converter
    
    override func setUp() {
        super.setUp()
        setTestDefaultCurrenciesNumbers()
        let exchangeService = ExchangeService(coreDataStack: MockCoreDataStack.create())
        containerRepository = exchangeService.containerRepository
    }
    
    override func tearDown() {
        containerRepository = nil
        super.tearDown()
    }
    
    func test_createContainers() {
        XCTAssertEqual(containerRepository.countOfContainers, 2)
    }
    
    func test_updateContainer() {
        runTest_updateContainer(with: exRateContainer)
        runTest_updateContainer(with: converterContainer)
    }
    
    func test_replaceInContainer() {
        runTest_replaceInContainer(with: exRateContainer)
        runTest_replaceInContainer(with: converterContainer)
    }
    
    func test_removeFromContainer() {
        runTest_removeFromContainer(with: exRateContainer)
        runTest_removeFromContainer(with: converterContainer)
    }
    
    private func runTest_updateContainer(with containerName: String, file: StaticString = #file, line: UInt = #line) {
        let expectedCodes = MockCurrency.currencyCodes
        
        let codes = containerRepository.currencyCodes(from: containerName)
        
        XCTAssertEqual(codes, expectedCodes, file: file, line: line)
    }
    
    private func runTest_replaceInContainer(
        with containerName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let initialCodes = MockCurrency.currencyCodes
        let expectedCodes = [
            MockCurrency.omaniReal.code, MockCurrency.usDollar.code, MockCurrency.ukrainianHryvnia.code
        ]
        guard initialCodes == containerRepository.currencyCodes(from: containerName) else {
            XCTFail("Codes Should Be The Same")
            return
        }
        
        containerRepository.replaceIn(container: containerName, at: 0, with: MockCurrency.omaniReal)
        containerRepository.replaceIn(container: containerName, at: 1, with: MockCurrency.usDollar)
        containerRepository.replaceIn(container: containerName, at: 2, with: MockCurrency.ukrainianHryvnia)
        
        let codes = containerRepository.currencyCodes(from: containerName)
        XCTAssertEqual(codes, expectedCodes, file: file, line: line)
    }
    
    private func runTest_removeFromContainer(
        with containerName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let canadianDollar = MockCurrency.canadianDollar
        let greatBritanPound = MockCurrency.greatBritanPound
        let expectedCodes = [MockCurrency.japaneseYen.code]
        
        containerRepository.removeFrom(container: containerName, currency: canadianDollar)
        containerRepository.removeFrom(container: containerName, currency: greatBritanPound)
        
        let codes = containerRepository.currencyCodes(from: containerName)
        XCTAssertEqual(codes, expectedCodes, file: file, line: line)
    }
}
