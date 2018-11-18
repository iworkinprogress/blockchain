//
//  Bitcoins.swift
//  TransactionsTests
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import XCTest
@testable import Transactions

class BitcoinTests: XCTestCase {

    func testSatoshiToBitcoinConversion() {
        let satoshi: Satoshi = 12345678
        let bitcoin = satoshi.toBitcoin
        XCTAssertTrue(bitcoin == 0.12345678)
    }
    
    func testSmallSatoshiToBitcoinConversion() {
        let satoshi: Satoshi = 13
        let bitcoin = satoshi.toBitcoin
        XCTAssertTrue(bitcoin == 0.00000013)
    }
    
    func testBitcoinString() {
        let satoshi: Satoshi = 987654321
        let bitcoin = satoshi.toBitcoin
        XCTAssertTrue(bitcoin.asString == "9.87654321 BTC")
    }
    
    func testBitcoinSmallString() {
        let satoshi: Satoshi = 1
        let bitcoin = satoshi.toBitcoin
        XCTAssertTrue(bitcoin.asString == "0.00000001 BTC")
    }
    
    func testBitcoinLargeString() {
        let satoshi: Satoshi = 9876543212345
        let bitcoin = satoshi.toBitcoin
        XCTAssertTrue(bitcoin.asString == "98,765.43212345 BTC")
    }
}
