//
//  TestPostGameOperation.swift
//  Tests
//
//  Created by Merch on 2018-02-02.
//  Copyright © 2018 Merch. All rights reserved.
//

import XCTest

class TestPostGameOperation: XCTestCase {
    

    func testPostGameOperation() {
        let exp = expectation(description: "expectation")

        let bundle = Bundle(for: type(of: self))
        let imageUrl = bundle.url(forResource: "city", withExtension: "png")!
        let imageData = try? Data(contentsOf: imageUrl)


        let coreDataManager = CoreDataManager()
        let postGameOperation = PostGameOperation(coreDataManager: coreDataManager, title: "City", developer: "Nintendo", year: "1990", image: imageData)
        postGameOperation.completionBlock = {
            exp.fulfill()
            XCTAssertTrue(postGameOperation.succeeded, "Post Game Operation didn't succeed.")
        }
        let queue = OperationQueue()
        queue.addOperation(postGameOperation)
        waitForExpectations(timeout: 60 * 10, handler: nil)

    }
    
}
