//
//  DateModelTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 19.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class DateModelTests: XCTestCase {
    private var coreDataStack: TestCoreDataStack!
    private var dateModel: DateModel!
    private var currentDate: Date!
    private var lastUpdateDate: Date!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        dateModel = DateModel(coreDataStack)
        currentDate = Date()
        lastUpdateDate = Date().startOfDay + 300
    }
    
    override func tearDown() {
        super.tearDown()
        currentDate = nil
        lastUpdateDate = nil
        coreDataStack = nil
        dateModel = nil
    }
    
    private var expectation: XCTestExpectation {
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.managedContext) { _ in
                return true
        }
    }
    
    func test_defaultLastUpdateDate() {
        let expectedDate = Date(timeIntervalSince1970: 197208000).dMMMyyyyHHmm
        XCTAssertEqual(dateModel.lastUpdateDate(), expectedDate)
    }
    
    func test_renewLastUpdateDate() {
        _ = expectation
        _ = dateModel.lastUpdateDate()
        dateModel.renew(updateDate: Date())
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        let lastUpdateDate = self.dateModel.lastUpdateDate()
        XCTAssertEqual(lastUpdateDate, self.currentDate.dMMMyyyyHHmm)
    }
    
    func test_checkPickerDate() {
        XCTAssertFalse(dateModel.checkPickerDate(currentDate), "False should be returned")
        XCTAssertTrue(dateModel.checkPickerDate(currentDate - 86400), "True should be returned")
    }
    
    func test_checkTimeIntervalToGivenDate() {
        var dates: [Date] = []
        dates.append(lastUpdateDate + 600)
        dates.append(lastUpdateDate + 3000)
        dates.append(lastUpdateDate + 3300)
        dates.append(lastUpdateDate + 3600)
        dates.append(lastUpdateDate - 86400)
        runTest_checkTimeIntervalToGivenDate(dates)
    }
    
    func test_nextUpdateHour() {
        var nextUpdateHourGMT: Int
        let timeZone = NSTimeZone.local
        timeZone.isDaylightSavingTime() ? (nextUpdateHourGMT = 0) : (nextUpdateHourGMT = 1)
        
        runTest_nextUpdateHour(currentDate: Date(timeIntervalSince1970: 1666310400), nextUpdateHourGMT + 1)
        runTest_nextUpdateHour(currentDate: Date(timeIntervalSince1970: 1666242300), nextUpdateHourGMT + 6)
        runTest_nextUpdateHour(currentDate: Date(timeIntervalSince1970: 1666292400), nextUpdateHourGMT + 20)
        runTest_nextUpdateHour(currentDate: Date(timeIntervalSince1970: 1666310399), nextUpdateHourGMT + 24)
    }
    
    private func runTest_checkTimeIntervalToGivenDate(
        _ dates: [Date],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        for (index, date) in dates.enumerated() {
            _ = expectation
            _ = dateModel.lastUpdateDate()
            dateModel.renew(updateDate: lastUpdateDate)
            
            waitForExpectations(timeout: 2.0) { error in
                XCTAssertNil(error, "Save did not occur")
            }
            switch index {
            case 0, 1:
                XCTAssertFalse(
                    self.dateModel.checkTimeInterval(from: date, to: Date()),
                    "False should be returned",
                    file: file,
                    line: line
                )
            case 2, 3:
                XCTAssertTrue(
                    self.dateModel.checkTimeInterval(from: date, to: Date()),
                    "True should be returned",
                    file: file,
                    line: line
                )
            case 4:
                XCTAssertTrue(
                    self.dateModel.checkTimeInterval(from: Date(), to: date),
                    "True should be returned",
                    file: file,
                    line: line
                )
            default:
                XCTFail("Something wrong")
            }
        }
    }
    
    private func runTest_nextUpdateHour(
        currentDate: Date,
        _ nextUpdateHourGMT: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectedHour = culculateExpectedHour(nextUpdateHourGMT)
        
        XCTAssertEqual(dateModel.nextUpdateHour(from: currentDate), expectedHour, file: file, line: line)
    }
    
    private func culculateExpectedHour(_ nextUpdateHourGMT: Int) -> Int {
        let timeZone = TimeZone.current
        let hoursFromGMT = timeZone.secondsFromGMT() / 3600
        var expectedHour = nextUpdateHourGMT + hoursFromGMT
        if expectedHour > 24 {
            expectedHour -= 24
        } else if expectedHour < 0 {
            expectedHour = 24 + expectedHour
        }
        return expectedHour
    }
}
