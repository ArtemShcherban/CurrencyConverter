//
//  RatesModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 23.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class RatesModelTests: XCTestCase {
    private var containerRepository: ContainerRepository!
    private var ratesModel: RatesModel!
    private var mainViewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        setTestDefaultCurrenciesNumbers()
        createMockMainViewController { controller in
            self.mainViewController = controller
        }
        containerRepository = mainViewController.exchangeService.containerRepository
        ratesModel = mainViewController.exchangeService.ratesModel
        ratesModel.delegate = mainViewController
    }
    
    override func tearDown() {
        containerRepository = nil
        mainViewController = nil
        ratesModel = nil
        super.tearDown()
    }
    
    func test_defineContainerName() {
        runTest_defineContainerName(isRatesView: true)
        runTest_defineContainerName(isRatesView: false)
    }
    
    func test_fillSelectedCurrencies() {
        runTest_fillSelectedCurrencies(isRatesView: true)
        runTest_fillSelectedCurrencies(isRatesView: false)
    }
    
    func test_replaceCurrency() {
        runTest_replaceCurrency(isRatesView: true)
        runTest_replaceCurrency(isRatesView: false)
    }
    
    func test_removeCell() {
        runTest_removeCell(isRatesView: true)
        runTest_removeCell(isRatesView: false)
    }
    
    func test_canAddRow() {
        runTest_canAddRow(isRatesView: true)
        runTest_canAddRow(isRatesView: false)
    }
    
    func test_addCurrency_toExRateContainer() {
        fillSelectedCurrencies(withValue: true)
        let initialCodes = MockCurrency.currencyCodes
        let expectedCodes = [
            MockCurrency.omaniReal.code, MockCurrency.ukrainianHryvnia.code, MockCurrency.usDollar.code
        ]
        
        guard initialCodes == containerRepository.currencyCodes(from: ratesModel.containerName) else {
            XCTFail("Codes Should Be The Same")
            return
        }
        
        removeCurenciesFromContainer(0...2)
        ratesModel.add(currency: MockCurrency.omaniReal)
        ratesModel.add(currency: MockCurrency.ukrainianHryvnia)
        ratesModel.add(currency: MockCurrency.usDollar)
        
        let codes = containerRepository.currencyCodes(from: ratesModel.containerName)
        
        XCTAssertEqual(codes, expectedCodes)
    }
    
    func test_addCurrency_toConverterContainer() {
        fillSelectedCurrencies(withValue: false)
        let initialCodes = MockCurrency.currencyCodes
        let expectedCodes = [
            MockCurrency.greatBritanPound.code, MockCurrency.omaniReal.code, MockCurrency.ukrainianHryvnia.code
        ]
        
        guard initialCodes == containerRepository.currencyCodes(from: ratesModel.containerName) else {
            XCTFail("Codes Should Be The Same")
            return
        }
        
        removeCurenciesFromContainer(0...1)
        ratesModel.add(currency: MockCurrency.omaniReal)
        ratesModel.add(currency: MockCurrency.ukrainianHryvnia)

        let codes = containerRepository.currencyCodes(from: ratesModel.containerName)
        
        XCTAssertEqual(codes, expectedCodes)
    }
    
    private func runTest_defineContainerName(isRatesView: Bool) {
        fillSelectedCurrencies(withValue: isRatesView)
        
        guard isRatesView else {
            XCTAssertEqual(ratesModel.containerName, ContainerName.converter)
            return
        }
        XCTAssertEqual(ratesModel.containerName, ContainerName.exRates)
    }
    
    private func runTest_fillSelectedCurrencies(isRatesView: Bool, file: StaticString = #file, line: UInt = #line) {
        fillSelectedCurrencies(withValue: isRatesView)
        let expectedBaseCurrency = MockCurrency.greatBritanPound
        let exRateSelectedCurrencies = MockCurrency.currencies
        let converterSelectedCurrencies = [MockCurrency.canadianDollar, MockCurrency.japaneseYen]
        
        guard let selectedCurencies = ratesModel.delegate?.selectedCurrencies else {
            XCTFail("Selected Currencies Should Not Be Nil", file: file, line: line)
            return
        }
        
        if isRatesView {
            XCTAssertEqual(selectedCurencies, exRateSelectedCurrencies)
            return
        }
         
        guard let baseCurrency = ratesModel.delegate?.baseCurrency else {
            XCTFail("Base Currency Should Not Be Nil", file: file, line: line)
            return
        }
        XCTAssertEqual(baseCurrency, expectedBaseCurrency)
        XCTAssertEqual(selectedCurencies, converterSelectedCurrencies)
    }
        
    private func runTest_replaceCurrency(isRatesView: Bool, file: StaticString = #file, line: UInt = #line) {
        fillSelectedCurrencies(withValue: isRatesView)
        let initialCodes = MockCurrency.currencyCodes
        let expectedCodes = [
            MockCurrency.omaniReal.code, MockCurrency.ukrainianHryvnia.code, MockCurrency.usDollar.code
        ]
        
        guard  initialCodes == containerRepository.currencyCodes(from: ratesModel.containerName) else {
            XCTFail("Codes Should Be The Same", file: file, line: line)
            return
        }
        
        ratesModel.replaceCurrency(at: 0, with: MockCurrency.omaniReal)
        ratesModel.replaceCurrency(at: 2, with: MockCurrency.usDollar)
        ratesModel.replaceCurrency(at: 1, with: MockCurrency.ukrainianHryvnia)
        
        let codes = containerRepository.currencyCodes(from: ratesModel.containerName)
        
        XCTAssertEqual(codes, expectedCodes)
    }
    
    private func runTest_removeCell(isRatesView: Bool, file: StaticString = #file, line: UInt = #line) {
        fillSelectedCurrencies(withValue: isRatesView)
        let exRateSelectedCodes = [MockCurrency.greatBritanPound.code, MockCurrency.japaneseYen.code]
        let converterSelectedCodes = [MockCurrency.greatBritanPound.code, MockCurrency.canadianDollar.code]
        
        ratesModel.removeCell(at: IndexPath(row: 1, section: 0))
        let codes = containerRepository.currencyCodes(from: ratesModel.containerName)
        
        guard isRatesView else {
            XCTAssertEqual(codes, converterSelectedCodes)
            return
        }
        XCTAssertEqual(codes, exRateSelectedCodes)
    }
    
    private func runTest_canAddRow(isRatesView: Bool, file: StaticString = #file, line: UInt = #line) {
        fillSelectedCurrencies(withValue: isRatesView)
        let exRatesMaxRow = 3
        let converterMaxRow = 2

        guard isRatesView else {
            XCTAssertEqual(ratesModel.delegate?.selectedCurrencies.count, converterMaxRow)
            XCTAssertFalse(ratesModel.canAddRow(), "False should be returned")
            return
        }
        XCTAssertEqual(ratesModel.delegate?.selectedCurrencies.count, exRatesMaxRow)
        XCTAssertFalse(ratesModel.canAddRow(), "False should be returned")
    }
    
    private func removeCurenciesFromContainer(_ range: ClosedRange<Int>) {
        for row in range.reversed() {
            ratesModel.removeCell(at: IndexPath(row: row, section: 0))
        }
    }
    
    private func fillSelectedCurrencies(withValue isRatesView: Bool) {
        ratesModel.defineContainerName(value: isRatesView)
        ratesModel.fillSelectedCurrencies()
    }
}
