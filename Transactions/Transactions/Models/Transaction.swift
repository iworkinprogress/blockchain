//
//  Transaction.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import Foundation

enum TransactionType: String {
    case sent
    case received
}

struct Transaction: Codable, CustomStringConvertible {
    let timestamp: Int64
    let amount: Int64
    let type: TransactionType
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "time"
        case amount = "result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Int64.self, forKey: .timestamp)
        amount = try container.decode(Int64.self, forKey: .amount)
        type = amount > 0 ? .received : .sent
    }
    
    var description: String {
        return "Amount: \(amount) at \(timestamp)"
    }
}

// Formatting
extension Transaction {
    var typeString: String {
        return type == .sent ? "Sent" : "Received"
    }
    
    var amountString: String {
        return "\(amount) BTC"
    }
    
    var dateString: String {
        return "01/01/2018"
    }
    
    var timeString: String {
        return "8:54pm"
    }
}
