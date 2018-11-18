//
//  Wallet.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import Foundation

struct Wallet: Codable, CustomStringConvertible {
    let balance: Int64
    let transactions: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case wallet = "wallet"
        case balance = "final_balance"
        case transactions = "txs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wallet = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wallet)
        self.balance = try wallet.decode(Int64.self, forKey: .balance)
        self.transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var wallet = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wallet)
        try wallet.encode(self.balance, forKey: .balance)
        try container.encode(self.transactions, forKey: .transactions)
    }
    
    var description: String {
        return "Balance: \(balance) \n Transactions: \(transactions)"
    }
}

extension Wallet {
    func transaction(at index: Int) -> Transaction? {
        guard (index < transactions.count) else {
            return nil
        }
        return transactions[index]
    }
}
