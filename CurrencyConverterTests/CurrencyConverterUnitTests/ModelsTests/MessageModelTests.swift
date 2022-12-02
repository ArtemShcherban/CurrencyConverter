//
//  MessageModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 23.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class MessageModelTests: XCTestCase {
    private var messageModel: MessageModel!
    private var mainViewController: MainViewController!

    override func setUp() {
        super.setUp()
        messageModel = MessageModel()
        mainViewController = MainViewController()
        messageModel.delegate = mainViewController
        
        var currencies = MockCurrency.currencies
        mainViewController.exchangeService.converterModel.amount = 15000
        mainViewController.baseCurrency = currencies.removeFirst()
        mainViewController.selectedCurrencies = currencies
    }

    override func tearDown() {
        messageModel = nil
        mainViewController = nil
        super.tearDown()
    }
    
    func test_createMessage_sellActionIsTrue() {
        let message = messageModel.createMessage(with: DateConstants.oneYearAgoString)

        XCTAssertEqual(message, MessageConstants.withSellAction)
    }
    
    func test_createMessage_sellActionIsFalse() {
        mainViewController.exchangeService.converterModel.isSellAction = false
        
        let message = messageModel.createMessage(with: DateConstants.oneYearAgoString)

        XCTAssertEqual(message, MessageConstants.withBuyAction)
    }
}
