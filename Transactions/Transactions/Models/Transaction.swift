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
    let timestamp: TimeInterval
    let amount: Int64
    let type: TransactionType
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "time"
        case amount = "result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        amount = try container.decode(Int64.self, forKey: .amount)
        type = amount > 0 ? .received : .sent
    }
    
    var description: String {
        return "Amount: \(amount) at \(timestamp)"
    }
}

// MARK: Dates
extension Transaction {
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}



extension Transaction {
    var typeString: String {
        return type == .sent ? "Sent" : "Received"
    }
    
    var amountString: String {
        return amount.toBitcoin.asString
    }
    
    var dateString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M/dd/yy"
        return dateformatter.string(from: date)
    }
    
    var timeString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "h:mm a"
        return dateformatter.string(from: date)
    }
}
