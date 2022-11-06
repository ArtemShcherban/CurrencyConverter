//
//  LastUpdateDateRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Artem Shcherban on 23.10.2022.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class LastUpdateDateRepositoryTests: XCTestCase {
    private var coreDataStack: CoreDataStack!
    private var dateRepository: LastUpdateDateRepository!
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        dateRepository = LastUpdateDateRepository(coreDataStack)
        dateRepository.create(lastUpdateDate: DateConstants.yesterday)
    }
    
    override func tearDown() {
        coreDataStack = nil
        dateRepository = nil
        super.tearDown()
    }
    
    private var expectation: XCTestExpectation {
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.managedContext) { _ in
                return true
        }
    }
    
    func testCreateLastUpdateDate() {
        XCTAssertEqual(dateRepository.date, DateConstants.yesterday)
    }
    
    func testUpdateLastUpdateDate() {
        dateRepository.update(with: DateConstants.today)
        
        _ = expectation
        
        waitForExpectations(timeout: 10.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        XCTAssertEqual(dateRepository.date, DateConstants.today)
    }
}
