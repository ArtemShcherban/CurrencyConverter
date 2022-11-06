//
//  ConverterViewTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 02.11.2022.
//

import XCTest
@testable import CurrencyConverter

final class ConverterViewTests: XCTestCase {
    private var converterView: ConverterView!
    private var mainViewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        createMockMainViewController { controller in
            self.converterView = controller.converterView
            self.mainViewController = controller
        }
        converterView.delegate = mainViewController
    }
    
    override func tearDown() {
        converterView = nil
        super.tearDown()
    }
    
    func test_tapBuyButton() {
        guard
            converterView.buyButton.isEnabled,
            !converterView.buyButton.isSelected,
            converterView.sellButton.isSelected,
            !converterView.sellButton.isEnabled else {
            XCTFail("BuyButton Should Be Enabled, SellButton Should Be Disabled")
            return
        }
        
        converterView.buyButton.simulateTap()
        
        XCTAssertTrue(converterView.sellButton.isEnabled)
        XCTAssertFalse(converterView.sellButton.isSelected)
        XCTAssertFalse(converterView.buyButton.isEnabled)
        XCTAssertTrue(converterView.buyButton.isSelected)
    }
    
    func test_tapSellButton() {
        converterView.buyButton.simulateTap()
        guard
            !converterView.buyButton.isEnabled,
            converterView.buyButton.isSelected,
            converterView.sellButton.isEnabled,
            !converterView.sellButton.isSelected else {
            XCTFail("BuyButton Should Be Disabled, SellButton Should Be Enabled")
            return
        }
        
        converterView.sellButton.simulateTap()
        
        XCTAssertFalse(converterView.sellButton.isEnabled)
        XCTAssertTrue(converterView.sellButton.isSelected)
        XCTAssertTrue(converterView.buyButton.isEnabled)
        XCTAssertFalse(converterView.buyButton.isSelected)
    }
    
    func test_valueChangedInTextField() {
        let initialString = "1234   5"
        let expectedString = "12 345"
        converterView.inputAmountTextField.text = initialString

        converterView.inputAmountTextField.simulateEditingChanged()
        
        let obtainedString = converterView.inputAmountTextField.text
        XCTAssertEqual(obtainedString, expectedString)
    }
}
