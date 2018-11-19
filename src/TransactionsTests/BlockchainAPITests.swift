//
//  BlockchainAPI.swift
//  TransactionsTests
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import XCTest
@testable import Transactions

class BlockchainAPITests: XCTestCase {
    
    private let walletAddress = "xpub6CfLQa8fLgtouvLxrb8EtvjbXfoC1yqzH6YbTJw4dP7srt523AhcMV8Uh4K3TWSHz9oDWmn9MuJogzdGU3ncxkBsAC9wFBLmFrWT9Ek81kQ"
    
    func testGetTransactionWithValidXPub() {
        let asyncExpectation = expectation(description: "Blockchain API Request")
        BlockchainAPI.getWallet(for: walletAddress) { (result) in
            switch(result) {
            case .success(let wallet):
                XCTAssertNotNil(wallet)
                XCTAssertTrue(wallet.transactions.count > 0)
            case .failure(_):
                XCTFail()
            }
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetTransactionWithInvalidXPub() {
        let asyncExpectation = expectation(description: "Blockchain API Request")
        BlockchainAPI.getWallet(for: "1234567890") { (result) in
            switch(result) {
            case .success:
                XCTFail()
            case .failure(let error):
                switch(error) {
                case .parseJson(let error):
                    XCTAssertNotNil(error)
                    break
                case .loadData, .unknownError:
                    XCTFail()
                }
            }
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
