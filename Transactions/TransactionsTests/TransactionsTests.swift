//
//  Transactions.swift
//  TransactionsTests
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import XCTest
@testable import Transactions

class Transactions: XCTestCase {
    
    let receivedTransaction = Transaction(
        timestamp: 1542518421,
        amount: 987654321,
        weight: 5874,
        size: 281,
        fee: 82)
    
    let sentTransaction = Transaction(
        timestamp: 1542518421,
        amount: -555555,
        weight: 5874,
        size: 281,
        fee: 82)
    
    func testSentType() {
        XCTAssertTrue(sentTransaction.type == .sent)
    }
    
    func testReceivedType() {
        XCTAssertTrue(receivedTransaction.type == .received)
    }
    
    func testDateString() {
        XCTAssertTrue(receivedTransaction.dateString == "11/18/18")
    }
    
    func testTimeString() {
        XCTAssertTrue(receivedTransaction.timeString == "12:20 AM")
    }
}
