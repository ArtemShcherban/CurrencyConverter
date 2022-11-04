//
//  ExchangeServiceTests.swift
//  ExchangeServiceTests
//
//  Created by Artem Shcherban on 17.07.2022.
//

import XCTest
@testable import CurrencyConverter

final class ExchangeServiceTests: XCTestCase {
    private var exchangeService: ExchangeService!
    
    override func setUp() {
        super.setUp()
        let coreDataStack = TestCoreDataStack()
        exchangeService = ExchangeService(coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        exchangeService = nil
    }

    func test_creatingCurrenciesList() {
        XCTAssertEqual(exchangeService.currenciesList.count, 156)
        XCTAssertEqual(exchangeService.currenciesList["USD"]?.number, 840)
        XCTAssertEqual(exchangeService.currenciesList["UAH"]?.country, "UKRAINE")
        XCTAssertEqual(exchangeService.currenciesList["EUR"]?.currency, "Euro")
    }
    
    func test_creatingGroups() {
        XCTAssertEqual(exchangeService.groups.count, 27)
        XCTAssertEqual(exchangeService.groups[0].name, "Popular")
        XCTAssertEqual(exchangeService.groups[1].name, "A")
        XCTAssertEqual(exchangeService.groups[15].name, "O")
        XCTAssertEqual(exchangeService.groups[26].name, "Z")
    }
}
