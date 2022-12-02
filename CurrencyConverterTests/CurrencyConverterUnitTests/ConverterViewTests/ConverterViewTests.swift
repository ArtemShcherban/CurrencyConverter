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
        mainViewController = createMockMainViewController()
        converterView = mainViewController.converterView
        converterView.delegate = mainViewController
    }
    
    override func tearDown() {
        converterView = nil
        super.tearDown()
    }
    
    func test_tapBuyButton() throws {
        guard
            converterView.buyButton.isEnabled,
            !converterView.buyButton.isSelected,
            converterView.sellButton.isSelected,
            !converterView.sellButton.isEnabled else {
            throw XCTSkip("BuyButton Should Be Enabled, SellButton Should Be Disabled")
        }
        
        converterView.buyButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(converterView.sellButton.isEnabled)
        XCTAssertFalse(converterView.sellButton.isSelected)
        XCTAssertFalse(converterView.buyButton.isEnabled)
        XCTAssertTrue(converterView.buyButton.isSelected)
    }
    
    func test_tapSellButton() throws {
        converterView.buyButton.sendActions(for: .touchUpInside)
        guard
            !converterView.buyButton.isEnabled,
            converterView.buyButton.isSelected,
            converterView.sellButton.isEnabled,
            !converterView.sellButton.isSelected else {
            throw XCTSkip("BuyButton Should Be Disabled, SellButton Should Be Enabled")
        }
        
        converterView.sellButton.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(converterView.sellButton.isEnabled)
        XCTAssertTrue(converterView.sellButton.isSelected)
        XCTAssertTrue(converterView.buyButton.isEnabled)
        XCTAssertFalse(converterView.buyButton.isSelected)
    }
    
    func test_valueChangedInTextField() {
        let initialString = "1234   5"
        let expectedString = "12 345"
        converterView.inputAmountTextField.text = initialString
        
        converterView.inputAmountTextField.sendActions(for: .editingChanged)
        
        let obtainedString = converterView.inputAmountTextField.text
        XCTAssertEqual(obtainedString, expectedString)
    }
    
    func test_maximumAllowedStringLength() {
        let validString = "999 999 999 999"
        let invalidString = "1 000 000 000 000"
        
        let obtainedTrue = converterView.textField(
            converterView.inputAmountTextField,
            shouldChangeCharactersIn: NSRange(),
            replacementString: validString
        )
        
        let obtainedFalse = converterView.textField(
            converterView.inputAmountTextField,
            shouldChangeCharactersIn: NSRange(),
            replacementString: invalidString
        )
        
        XCTAssertEqual(obtainedTrue, true)
        XCTAssertEqual(obtainedFalse, false)
    }
}
