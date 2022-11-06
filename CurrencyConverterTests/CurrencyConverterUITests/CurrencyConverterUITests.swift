//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Artem Shcherban on 17.07.2022.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterUITests: XCTestCase {
    private var app: XCUIApplication!
    private lazy var buyButton = app.buttons["buyButton"]
    private lazy var sellButton = app.buttons["sellButton"]
    private lazy var exRatesAddButton = app.buttons["exRatesAddButton"]
    private lazy var converterAddButton = app.buttons["converterAddButton"]
    private lazy var amountTextField = app.textFields["amountTextField"]
    private lazy var switchViewButton = app.buttons["switchViewButton"]
    private lazy var currencyListTableView = app.tables["currencyListTableView"]
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        
        app.launchArguments.append("IS_RUNNING_UITEST")
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_tapSwitchViewButton_ConverterViewAppear() {
        let expectedTitle = "Currency Converter"
        let expectedButtonTitle = "Exchange Rates"
        
        switchViewButton.tap()
        
        let title = app.staticTexts["titleLabel"].label
        let buttonTitle = app.buttons["switchViewButton"].label
        
        XCTAssertEqual(title, expectedTitle)
        XCTAssert(sellButton.exists)
        XCTAssert(buyButton.exists)
        XCTAssert(amountTextField.exists)
        XCTAssertEqual(buttonTitle, expectedButtonTitle)
    }
    
    func test_tapDateTextField_DatePickerAppear() {
        app.textFields["dateTextField"].tap()
        
        let datePicker = app.datePickers["datePicker"]
        
        XCTAssert(datePicker.exists)
    }
    
    func test_tapCurrencyButton_CurrencyListVCAppear() {
        let cell = app.tables.cells.element(boundBy: 1)
        
        cell.buttons["rateCellCurrencyButton"].tap()
        
        XCTAssert(currencyListTableView.exists)
    }
    
    func test_tapExRatesAddButton_CurrencyListVCAppear() {
        let cell = app.tables.cells.element(boundBy: 1)
        cell.swipeLeft()
        cell.buttons["Delete"].tap()

        exRatesAddButton.tap()
        
        XCTAssert(currencyListTableView.exists)
    }
    
    func test_tapCellInCurrencyListTableView_addCellInExRatesTableView() {
        let exRatesTableView = app.tables["exRatesTableView"]
        let secondCell = exRatesTableView.cells.element(boundBy: 1)
        let thirdCell = exRatesTableView.cells.element(boundBy: 2)
        secondCell.swipeLeft()
        secondCell.buttons["Delete"].tap()
        var numberOfCell = exRatesTableView.cells.count
        numberOfCell == 2 ? nil : XCTFail("Should Be Two Cells")

        exRatesAddButton.tap()
        currencyListTableView.cells.element(boundBy: 7).tap()
        numberOfCell = exRatesTableView.cells.count

        XCTAssertEqual(numberOfCell, 3)
        XCTAssertEqual(thirdCell.buttons.element.label, "AUD")
    }
    
    func test_tapHelpButton_HintAppear() {
        let expectedHint = "Сlick on the date field to change the date."
        let helpButton = app.buttons["helpButton"]
        
        helpButton.tap()
        let hint = app.staticTexts["lastUpdatedLabel"].label
        
        XCTAssertEqual(hint, expectedHint)
        XCTAssertFalse(helpButton.isEnabled)
    }
    
    func test_baseCurrencyButton_CurrencyListVCAppear() {
        let baseCurrencyButton = app.buttons["baseCurrencyButton"]
        switchViewButton.tap()
        
        baseCurrencyButton.tap()
        
        XCTAssertTrue(currencyListTableView.exists)
    }
    
    func test_tapConverterCellCurrencyButton_CurrencyListVCAppear() {
        let cell = app.tables.cells.element(boundBy: 0)
        let converterCellCurrencyButton = cell.buttons["converterCellCurrencyButton"]
        switchViewButton.tap()
        
        converterCellCurrencyButton.tap()
        
        XCTAssertTrue(currencyListTableView.exists)
    }
    
    func test_tapConverterAddButton_CurrencyListVCAppear() {
        switchViewButton.tap()
        let cell = app.tables.cells.element(boundBy: 1)
        cell.swipeLeft()
        cell.buttons["Delete"].tap()

        converterAddButton.tap()
        
        XCTAssert(currencyListTableView.exists)
    }
    
    func test_entering18Digits_ReturnStringOf12Characters() {
        let inputString = "123456789012345678"
        let expectedString = "123 456 789 012"
        switchViewButton.tap()
        amountTextField.tap()
        
        amountTextField.typeText(inputString)
        
        XCTAssertEqual(amountTextField.value as? String, expectedString)
    }
    
    func test_tapSendButton_ActivityListViewAppear() {
        let activityListView = app.otherElements["ActivityListView"]
        let sendMessageButton = app.buttons["sendMessageButton"]
        switchViewButton.tap()
        
        sendMessageButton.tap()
        
        XCTAssertTrue(activityListView.waitForExistence(timeout: 1))
    }
}
