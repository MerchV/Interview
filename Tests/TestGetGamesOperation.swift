//
//  TestGamesOperation.swift
//  Tests
//
//  Created by Merch on 2018-01-29.
//  Copyright © 2018 Merch. All rights reserved.
//

import XCTest

class TestGetGamesOperation: XCTestCase {
    

    func testGetGamesOperation() {

        let exp = expectation(description: "expectation")

        let coreDataManager = CoreDataManager()
        let getGamesOperation = GetGamesOperation(coreDataManager: coreDataManager)
        getGamesOperation.completionBlock = {
            exp.fulfill()
            XCTAssertTrue(getGamesOperation.succeeded, "Get Games Operation didn't succeed.")
        }
        let queue = OperationQueue()
        queue.addOperation(getGamesOperation)
        waitForExpectations(timeout: 60 * 10, handler: nil) // needed for asynchronous tests



    }



}
