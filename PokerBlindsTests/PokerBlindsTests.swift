//
//  PokerBlindsTests.swift
//  PokerBlindsTests
//
//  Created by Adam Reed on 9/7/23.
//

import XCTest

final class PokerBlindsTests: XCTestCase {

    let payoutsVM = PayoutsViewModel()
    
    func test_payout_with_split() {
        let sut = PayoutsViewModel()
        
        let actual = sut.splitPotPayout
        let expected = 0
        // expected output is to split the pot evenly since 25k is half of 50k
        XCTAssertEqual(actual, expected)
        
    }
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
