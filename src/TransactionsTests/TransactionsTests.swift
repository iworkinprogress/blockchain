//
//  Transactions.swift
//  TransactionsTests
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import XCTest
@testable import Transactions

class Transactions: XCTestCase {
    
    let receivedTransaction = Transaction(
        timestamp: 1542518421,
        amount: 987654321,
        hash: "85ec49c884f9ebce4a713032dbf73834ab756f79c2e02294450fe92f8a817d25",
        weight: 5874,
        size: 281,
        fee: 82)
    
    let sentTransaction = Transaction(
        timestamp: 1542518421,
        amount: -555555,
        hash: "85ec49c884f9ebce4a713032dbf73834ab756f79c2e02294450fe92f8a817d25",
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
    
    func testDecoder() {
        let json = """
        {
            "hash": "85ec49c884f9ebce4a713032dbf73834ab756f79c2e02294450fe92f8a817d25",
            "ver": 1,
            "vin_sz": 5,
            "vout_sz": 2,
            "size": 817,
            "weight": 3268,
            "fee": 9816,
            "relayed_by": "127.0.0.1",
            "lock_time": 0,
            "tx_index": 389384005,
            "double_spend": false,
            "result": -17791,
            "balance": 62054,
            "time": 1542205548,
            "block_height": 550064,
        }
        """
        do {
            let transaction = try JSONDecoder().decode(Transaction.self, from: json.data(using: .utf8)!)
            XCTAssertTrue(transaction.amount == -17791)
            XCTAssertTrue(transaction.weight == 3268)
            XCTAssertTrue(transaction.fee == 9816)
            XCTAssertTrue(transaction.size == 817)
            XCTAssertTrue(transaction.type == .sent)
            XCTAssertTrue(transaction.timestamp == 1542205548)
            XCTAssertTrue(transaction.hash == "85ec49c884f9ebce4a713032dbf73834ab756f79c2e02294450fe92f8a817d25")
        } catch {
            XCTFail()
        }
    }
}
