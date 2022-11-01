//
//  ConverterModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 23.10.2022.
//

import XCTest
@testable import CurrencyConverter

final class ConverterModelTests: XCTestCase {
    private var converterModel: ConverterModel!
    private var currency: Currency!
    private var baseCurrency: Currency!
    
    override func setUp() {
        super.setUp()
        converterModel = ConverterModel()
        currency = MockCurrency.japaneseYen
        baseCurrency = MockCurrency.canadianDollar
        
        converterModel.amount = 240.0
    }
    
    override func tearDown() {
        converterModel = nil
        super.tearDown()
    }
    
    func testTransformText() {
        XCTAssertEqual(converterModel.transform("qwerty"), "240")
        XCTAssertEqual(converterModel.transform(" "), "240")
        XCTAssertEqual(converterModel.transform("235  55"), "23 555")
        XCTAssertEqual(converterModel.transform("235.559"), "235.55")
        XCTAssertEqual(converterModel.transform("23 55."), "2 355.")
        XCTAssertEqual(converterModel.transform("2 3 5 5.5 0"), "2 355.50")
        XCTAssertEqual(converterModel.transform("2 3 5 5.0"), "2 355.0")
        XCTAssertEqual(converterModel.transform("23 55 .4 50"), "2 355.45")
    }
    
    func test_doCalculation_sellActionIsTrue() {
        let expectedResult = 24960.0
        
        let result = converterModel.doCalculation(for: currency, with: baseCurrency)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_doCalculation_sellActionIsFalse() {
        converterModel.isSellAction = false
        let expectedResult = 28000.0
        
        let result = converterModel.doCalculation(for: currency, with: baseCurrency)
        
        XCTAssertEqual(result, expectedResult)
    }
}
