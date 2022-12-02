//
//  ExchangeRateRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 21.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class ExchangeRateRepositoryTests: XCTestCase {
    private var exRateRepository: ExchangeRateRepository!
    
    private let today = DateConstants.today
    private let yesterday = DateConstants.yesterday
    private let twoDaysAgo = DateConstants.twoDaysAgo
    private var dates: [Date]!
    private let greatBritanPound = MockCurrency.greatBritanPound
    private let canadianDollar = MockCurrency.canadianDollar
    private let japaneseYen = MockCurrency.japaneseYen
    private var exRates: [ExchangeRate]!
    
    override func setUp() {
        super.setUp()
        exRateRepository = ExchangeRateRepository(coreDataStack: MockCoreDataStack.create())
        dates = [today, yesterday, twoDaysAgo]
        createBulletins(for: dates)
        exRates = createExRates(for: dates)
    }
    
    override func tearDown() {
        exRateRepository = nil
        dates = []
        super.tearDown()
    }
    
    func testCreateBulletin() {
        XCTAssertTrue(self.exRateRepository.checkBulletin(for: today.startOfDay), "True should be returned")
        XCTAssertTrue(self.exRateRepository.checkBulletin(for: yesterday.startOfDay), "True should be returned")
        XCTAssertTrue(self.exRateRepository.checkBulletin(for: twoDaysAgo.startOfDay), "True should be returned")
    }
    
    func test_readExchangeRate() {
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: twoDaysAgo), exRates[0])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: twoDaysAgo), exRates[1])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: twoDaysAgo), exRates[2])
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: yesterday), exRates[3])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: yesterday), exRates[4])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: yesterday), exRates[5])
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: today), exRates[6])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: today), exRates[7])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: today), exRates[8])
    }
    
    func test_handleSaving_WithUpdateExRate() {
        exRates = createExRates(for: dates, multiplier: 1.1)
        
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: twoDaysAgo), exRates[0])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: twoDaysAgo), exRates[1])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: twoDaysAgo), exRates[2])
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: yesterday), exRates[3])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: yesterday), exRates[4])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: yesterday), exRates[5])
        XCTAssertEqual(exRateRepository.exchangeRate(for: greatBritanPound, on: today), exRates[6])
        XCTAssertEqual(exRateRepository.exchangeRate(for: canadianDollar, on: today), exRates[7])
        XCTAssertEqual(exRateRepository.exchangeRate(for: japaneseYen, on: today), exRates[8])
    }
    
    func testDeleteBulletin() {
        // swiftlint:disable identifier_name
        let date21_10_22 = DateConstants.date21_10_22
        let date19_10_22 = DateConstants.date19_10_22
        let date18_10_22 = DateConstants.date18_10_22
        let date17_10_22 = DateConstants.date17_10_22
        let date15_10_22 = DateConstants.date15_10_22
        // swiftlint:enable identifier_name
        
        let additionalDates = [date15_10_22, date17_10_22, date18_10_22, date19_10_22, date21_10_22]
        createBulletins(for: additionalDates)
        
        exRateRepository.deleteBulletin(before: date19_10_22)
        
        XCTAssertTrue(exRateRepository.checkBulletin(for: today))
        XCTAssertTrue(exRateRepository.checkBulletin(for: yesterday))
        XCTAssertTrue(exRateRepository.checkBulletin(for: twoDaysAgo))
        XCTAssertTrue(exRateRepository.checkBulletin(for: date21_10_22))
        XCTAssertTrue(exRateRepository.checkBulletin(for: date19_10_22))
        XCTAssertFalse(exRateRepository.checkBulletin(for: date18_10_22))
        XCTAssertFalse(exRateRepository.checkBulletin(for: date17_10_22))
        XCTAssertFalse(exRateRepository.checkBulletin(for: date15_10_22))
    }
    
    private func createBulletins(for dates: [Date]) {
        dates.forEach { date in
            let bulletin = Bulletin(from: "TestBank", date: date.startOfDay)
            exRateRepository.create(bulletin: bulletin)
        }
    }
    
    private func createExRates(for dates: [Date], multiplier: Double = 1.0) -> [ExchangeRate] {
        var exRates: [ExchangeRate] = []
        let mockExRates = MockExRate.exRates
        var multiplier = multiplier
        dates.reversed().forEach { date in
            mockExRates.forEach {
                let exRate = ExchangeRate(
                    buy: $0.buy * multiplier,
                    sell: $0.sell * multiplier,
                    currencyNumber: $0.currencyNumber)
                exRates.append(exRate)
                exRateRepository.handleSaving(exchangeRate: exRate, on: date)
            }
            multiplier += 0.05
        }
        return exRates
    }
}
