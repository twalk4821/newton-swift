//
//  newton_swiftTests.swift
//  newton-swiftTests
//
//  Created by Tyler Walker on 8/3/17.
//  Copyright © 2017 Tyler Walker. All rights reserved.
//

import XCTest
@testable import newton-swift

class newton_swiftTests: XCTestCase {
    
    let ENDPOINTS = ["simplify", "factor", "derive", "integrate", "zeroes",
                     "tangent", "area", "cos", "sin", "tan", "arccos",
                     "arcsin", "arctan", "abs", "log"]
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldEncodeURL() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expression = "x^2"
        let operation = "derive"
        XCTAssertTrue(NewtonAPI.makeRouteWithEncodedExpression(forOperation: operation, expression: expression) == "https://newton.now.sh/derive/x%5E2")
        
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
