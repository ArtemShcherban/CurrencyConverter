//
//  ExchangeRateModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 24.10.2022.
//

import XCTest
import Combine
import CoreData
@testable import CurrencyConverter

class ExchangeRateModelTests: XCTestCase {
    private var networkService: NetworkService!
    private var mockURLSession: MockURLSession!
    private var exchangeService: ExchangeService!
    private var exchangeRateModel: ExchangeRateModel!
    private var oneYearAgo = DateConstants.oneYearAgo

    override func setUpWithError() throws {
        try super.setUpWithError()
        let coreDataStack = TestCoreDataStack()
        networkService = NetworkService()
        mockURLSession = MockURLSession()
        exchangeService = ExchangeService(coreDataStack)
        exchangeRateModel = exchangeService.exchangeRateModel
        exchangeRateModel.networkService = networkService
    }

    override func tearDown() {
        networkService = nil
        mockURLSession = nil
        exchangeService = nil
        exchangeRateModel = nil
        super.tearDown()
    }

    func test_getExchangeRatesFromMonoBank() {
        mockURLSession.createTestData(for: .monoBank)
        networkService.urlSession = mockURLSession.byDefault
        let exRateRepo = exchangeRateModel.exchangeRateRepository
        let expectation = expectation(description: "Data from MonoBank received")
        var resultCount = 0
        
        exchangeRateModel.exchangeRates(for: oneYearAgo) { _ in
            resultCount += 1
            resultCount == 1 ? expectation.fulfill() : nil
        }
        
        waitForExpectations(timeout: 1.0)
        let cadExRate = exRateRepo.exchangeRate(
            for: MockCurrency.canadianDollar,
            on: oneYearAgo
        )
        let gbpExRate = exRateRepo.exchangeRate(
            for: MockCurrency.greatBritanPound,
            on: oneYearAgo
        )
        let jpyExRate = exRateRepo.exchangeRate(
            for: MockCurrency.japaneseYen,
            on: oneYearAgo
        )
        
        XCTAssertEqual(cadExRate?.buy.decimalFormattedString(3), "26.089")
        XCTAssertEqual(cadExRate?.sell.decimalFormattedString(3), "28.836")
        XCTAssertEqual(cadExRate?.currencyNumber, MockCurrency.canadianDollar.number)
        XCTAssertEqual(gbpExRate?.buy.decimalFormattedString(3), "40.105")
        XCTAssertEqual(gbpExRate?.sell.decimalFormattedString(3), "44.326")
        XCTAssertEqual(gbpExRate?.currencyNumber, MockCurrency.greatBritanPound.number)
        XCTAssertEqual(jpyExRate?.buy.decimalFormattedString(3), "0.241")
        XCTAssertEqual(jpyExRate?.sell.decimalFormattedString(3), "0.266")
        XCTAssertEqual(jpyExRate?.currencyNumber, MockCurrency.japaneseYen.number)
    }

    func test_getExchangeRatesFromPrivatBank() {
        mockURLSession.createTestData(for: .privatBank(with: oneYearAgo))
        networkService.urlSession = mockURLSession.byDefault
        let exRateRepo = exchangeRateModel.exchangeRateRepository
        let expectation = expectation(description: "Data from PrivatBank received")
        var resultCount = 0
        
        exchangeRateModel.exchangeRates(for: oneYearAgo) { _ in
            resultCount += 1
            resultCount == 2 ? expectation.fulfill() : nil
        }
        
        waitForExpectations(timeout: 1.0)
        let cadExRate = exRateRepo.exchangeRate(
            for: MockCurrency.canadianDollar,
            on: oneYearAgo
        )
        let gbpExRate = exRateRepo.exchangeRate(
            for: MockCurrency.greatBritanPound,
            on: oneYearAgo
        )
        let jpyExRate = exRateRepo.exchangeRate(
            for: MockCurrency.japaneseYen,
            on: oneYearAgo
        )
        
        XCTAssertEqual(cadExRate?.buy.decimalFormattedString(3), "13.000")
        XCTAssertEqual(cadExRate?.sell.decimalFormattedString(3), "15.000")
        XCTAssertEqual(cadExRate?.currencyNumber, MockCurrency.canadianDollar.number)
        XCTAssertEqual(gbpExRate?.buy.decimalFormattedString(3), "24.000")
        XCTAssertEqual(gbpExRate?.sell.decimalFormattedString(3), "25.800")
        XCTAssertEqual(gbpExRate?.currencyNumber, MockCurrency.greatBritanPound.number)
        XCTAssertEqual(jpyExRate?.buy.decimalFormattedString(3), "0.120")
        XCTAssertEqual(jpyExRate?.sell.decimalFormattedString(3), "0.150")
        XCTAssertEqual(jpyExRate?.currencyNumber, MockCurrency.japaneseYen.number)
    }
    
    func test_setExRateforUkrainianHrivnia() {
        let ukrainianHrivnia = exchangeRateModel.setExchangeRate(for: MockCurrency.ukrainianHryvnia)
        
        XCTAssertEqual(ukrainianHrivnia.buy, 1.0)
        XCTAssertEqual(ukrainianHrivnia.sell, 1.0)
    }
}
