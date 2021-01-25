//
//  EntriesListViewModelTest.swift
//  RedditAppTests
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import XCTest
@testable import RedditApp

class EntriesListViewModelTest: XCTestCase {

    func testCompletion() {
        let client = RedditProvider()
        let topEntriesViewModel = EntriesListViewModel(withClient: client)
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertEqual(topEntriesViewModel.entries.count, 30)
            XCTAssertFalse(topEntriesViewModel.hasError)
            
            topEntriesViewModel.entries.forEach { entryViewModel in
                
                XCTAssertFalse(entryViewModel.hasError)
            }
            
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }

    func testPerformanceExample() throws {
        let client = TestErrorClient()
        let topEntriesViewModel = EntriesListViewModel(withClient: client)
        
        let waitExpectation = expectation(description: "Wait for loadEntries to complete.")
        
        topEntriesViewModel.loadEntries {
            
            XCTAssertTrue(topEntriesViewModel.hasError)
            XCTAssertEqual(topEntriesViewModel.errorMessage, TestErrorClient.testErrorMessage)
            waitExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }

}

class TestErrorClient: ProviderProtocol {
    
    static let testErrorMessage = "TEST_ERROR"

    func getTopEntries(after lastEntry: String?, limit maxCount: Int, completionHandler: @escaping ([String: AnyObject]) -> (), errorHandler: @escaping (_ message: String) -> ()) {
        
        errorHandler(TestErrorClient.testErrorMessage)
    }
}
