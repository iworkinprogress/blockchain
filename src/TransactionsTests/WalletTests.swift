//
//  Wallet.swift
//  TransactionsTests
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import XCTest
@testable import Transactions

class WalletTests: XCTestCase {

    func testDecoder() {
        let json = """
        {
            "wallet": {
                "n_tx": 379,
                "n_tx_filtered": 379,
                "total_received": 29156099,
                "total_sent": 29094045,
                "final_balance": 62054
              },
              "txs": [
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
                },
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
            ],
        }
        """
        do {
            let wallet = try JSONDecoder().decode(Wallet.self, from: json.data(using: .utf8)!)
            XCTAssertTrue(wallet.balance == 62054)
            XCTAssertTrue(wallet.transactions.count == 2)
        } catch {
            XCTFail()
        }
    }

}
