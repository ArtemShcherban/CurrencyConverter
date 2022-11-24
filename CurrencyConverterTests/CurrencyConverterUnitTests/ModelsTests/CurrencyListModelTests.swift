//
//  CurrencyListModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 31.10.2022.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyListModelTests: XCTestCase {
    private var currencyListModel: CurrencyListModel!
    private var containerRepository: ContainerRepository!
    private var currencyListViewController: CurrencyListViewController!
    private var mainViewController: MainViewController!
    private let exRateContainer = ContainerName.exchangeRates
    private let converterContainer = ContainerName.converter
    
    override func setUp() {
        super.setUp()
        setTestDefaultCurrenciesNumbers()
        mainViewController = createMockMainViewController()
        let rateModel = mainViewController.exchangeService.ratesModel
        currencyListViewController = CurrencyListViewController.instantiateWith(
            ratesModel: rateModel,
            and: nil
        )
        currencyListModel = CurrencyListModel(coreDataStack: ExchangeService.coreDataStack)
        containerRepository = currencyListModel.containerRepository
        setModelDelegates()
    }
    
    override func tearDown() {
        currencyListModel = nil
        containerRepository = nil
        currencyListViewController = nil
        mainViewController = nil
        super.tearDown()
    }
    
    func test_currenciesForTableView() {
        runTest_currenciesForTableView(containerName: exRateContainer)
        runTest_currenciesForTableView(containerName: converterContainer)
    }
    
    func test_filterCurrency() {
        runTest_filterCurrency(containerName: exRateContainer)
        runTest_filterCurrency(containerName: converterContainer)
    }
    
    func test_selectedCurrency() {
        runTest_selectedCurrency(containerName: exRateContainer)
        runTest_selectedCurrency(containerName: converterContainer)
    }
    
    func test_selectedFilteredCurrency_withRateContainerName() {
        runTest_selectedFilteredCurrency(containerName: exRateContainer)
        runTest_selectedFilteredCurrency(containerName: converterContainer)
    }
    
    func test_groupTitle() {
        runTest_groupTitle_whenTableView(isFiltered: true, containerName: exRateContainer)
        runTest_groupTitle_whenTableView(isFiltered: true, containerName: exRateContainer, text: "CAR")
        runTest_groupTitle_whenTableView(isFiltered: false, containerName: exRateContainer)
        runTest_groupTitle_whenTableView(isFiltered: true, containerName: converterContainer)
        runTest_groupTitle_whenTableView(isFiltered: true, containerName: converterContainer, text: "CAR")
        runTest_groupTitle_whenTableView(isFiltered: false, containerName: converterContainer)
    }
    
    private func runTest_currenciesForTableView(
        containerName: String, file: StaticString = #file, line: UInt = #line
    ) {
        let amountOfCurrencies = 153
        let amountOfGroups = 27
        let expectedFirstGroup = "Popular"
        let expectedOGroup = "O"
        let expectedLastGroup = "Z"
        
        populateModel(containerName: containerName)
        guard
            let currenciesInTableView = currencyListModel.delegate?.currenciesInTableView,
            let groupsInTableView = currencyListModel.delegate?.groups else {
            XCTFail("Currencies should present")
            return
        }
        
        let ukrainianHrivnia = currenciesInTableView.first { $0.code == MockCurrency.ukrainianHryvnia.code }
        let canadianDollar = currenciesInTableView.first { $0.code == MockCurrency.canadianDollar.code }
        let greatBritanPound = currenciesInTableView.first { $0.code == MockCurrency.greatBritanPound.code }
        let japaneseYen = currenciesInTableView.first { $0.code == MockCurrency.japaneseYen.code }
        let usDollar = currenciesInTableView.first { $0.code == MockCurrency.usDollar.code }
        let omaniReal = currenciesInTableView.first { $0.code == MockCurrency.omaniReal.code }
        let firstGroup = groupsInTableView.first
        let oGroup = groupsInTableView[15]
        let lastGroup = groupsInTableView.last
        
        XCTAssertEqual(currenciesInTableView.count, amountOfCurrencies)
        XCTAssertEqual(groupsInTableView.count, amountOfGroups)
        XCTAssertNotNil(ukrainianHrivnia, "Currency should be in list")
        XCTAssertNotNil(usDollar, "Currency should be in list")
        XCTAssertNotNil(omaniReal, "Currency should be in list")
        XCTAssertNil(canadianDollar, "Currency should be in list")
        XCTAssertNil(greatBritanPound, "Currency should be in list")
        XCTAssertNil(japaneseYen, "Currency should be in list")
        XCTAssertEqual(firstGroup?.name, expectedFirstGroup)
        XCTAssertEqual(firstGroup?.key, 0)
        XCTAssertEqual(oGroup.name, expectedOGroup)
        XCTAssertEqual(oGroup.key, 15)
        XCTAssertEqual(lastGroup?.name, expectedLastGroup)
        XCTAssertEqual(lastGroup?.key, 26)
    }
    
    private func runTest_filterCurrency(
        containerName: String, file: StaticString = #file, line: UInt = #line
    ) {
        let amountOfFiltered = 2
        let dominica = "DOMINICA"
        let nicaragua = "NICARAGUA"
        populateModel(containerName: containerName)
        
        currencyListModel.filterCurrency(text: "CAR")
        guard
            let filteredCurrencies = currencyListModel.delegate?.filteredCurrency,
            !filteredCurrencies.isEmpty else {
            XCTFail("FilteredCurrencies - Should Not Be Empty Or Nil")
            return
        }
        
        XCTAssertEqual(filteredCurrencies.count, amountOfFiltered)
        XCTAssertEqual(filteredCurrencies[0].country, nicaragua)
        XCTAssertEqual(filteredCurrencies[1].country, dominica)
    }
    
    private func runTest_selectedCurrency(
        containerName: String, file: StaticString = #file, line: UInt = #line
    ) {
        populateModel(containerName: containerName)
        guard
            let usDollar = currencyListModel.selectedCurrency(at: IndexPath(row: 0, section: 0)),
            let omaniReal = currencyListModel.selectedCurrency(at: IndexPath(row: 0, section: 15)),
            let ukrainianHrivnia = currencyListModel.selectedCurrency(at: IndexPath(row: 2, section: 0)) else {
            return
        }
        
        XCTAssertEqual(usDollar, MockCurrency.usDollar)
        XCTAssertEqual(omaniReal, MockCurrency.omaniReal)
        XCTAssertEqual(ukrainianHrivnia, MockCurrency.ukrainianHryvnia)
    }
    
    private func runTest_selectedFilteredCurrency(containerName: String) {
        populateModel(containerName: containerName)
        
        currencyListModel.filterCurrency(text: "OM")
        
        let omaniReal = currencyListModel.selectedFilteredCurrency(at: IndexPath(row: 5, section: 0))
        XCTAssertEqual(omaniReal, MockCurrency.omaniReal)
    }
    
    private func runTest_groupTitle_whenTableView(
        isFiltered: Bool,
        containerName: String,
        text: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        populateModel(containerName: containerName)
        currencyListModel.filterCurrency(text: text)
        let tableView = CurrencyListTableView()
        tableView.isFiltered = isFiltered
        
        guard isFiltered else {
            let oTitle = currencyListModel.groupTitle(for: 15, in: tableView)
            let popularTitle = currencyListModel.groupTitle(for: 0, in: tableView)
            let zTitle = currencyListModel.groupTitle(for: 26, in: tableView)
            
            XCTAssertEqual(oTitle, "O")
            XCTAssertEqual(popularTitle, "Popular")
            XCTAssertEqual(zTitle, "Z")
            return
        }
        
        let groupTitle = currencyListModel.groupTitle(for: 0, in: tableView)
        text.isEmpty ?
        XCTAssertEqual(groupTitle, "No currency found") :
        XCTAssertEqual(groupTitle, "Search result:")
    }
    
    private func populateModel(containerName: String) {
        currencyListModel.containerName = containerName
        currencyListModel.currenciesForTableView()
    }
    
    private func setModelDelegates() {
        currencyListModel.delegate = currencyListViewController
        currencyListModel.delegate?.ratesModelDelegate = mainViewController
    }
}
