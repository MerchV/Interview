//
//  TestDeleteGameOperation.swift
//  Tests
//
//  Created by Merch on 2018-01-29.
//  Copyright © 2018 Merch. All rights reserved.
//

import XCTest

class TestDeleteGameOperation: XCTestCase {
    

    func testDeleteGameOperation() {

        let exp = expectation(description: "expectation")

        let coreDataManager = CoreDataManager()
        let deleteGameOperation = DeleteGameOperation(coreDataManager: coreDataManager, id: 1)
        deleteGameOperation.completionBlock = {
            exp.fulfill()
            XCTAssertTrue(deleteGameOperation.succeeded, "Delete Game Operation didn't succeed.")
        }
        let queue = OperationQueue()
        queue.addOperation(deleteGameOperation)
        waitForExpectations(timeout: 60 * 10, handler: nil)

    }
    
}
