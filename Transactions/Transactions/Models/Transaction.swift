//
//  Transaction.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import Foundation

enum TransactionType: String {
    case sent
    case received
}

struct Transaction: Codable {
    let timestamp: TimeInterval
    let amount: Satoshi
    let type: TransactionType
    let weight: Int64
    let size: Int64
    let fee: Satoshi
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "time"
        case amount = "result"
        case weight
        case size
        case fee
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
        amount = try container.decode(Satoshi.self, forKey: .amount)
        weight = try container.decode(Int64.self, forKey: .weight)
        size = try container.decode(Int64.self, forKey: .size)
        fee = try container.decode(Satoshi.self, forKey: .fee)
        type = amount > 0 ? .received : .sent
    }
    
    init(timestamp: TimeInterval, amount: Satoshi, weight: Int64, size: Int64, fee: Satoshi) {
        self.timestamp = timestamp
        self.amount = amount
        self.type = amount < 0 ? .sent : .received
        self.weight = weight
        self.size = size
        self.fee = fee
    }
}

// MARK: Dates
extension Transaction {
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}


// MARK: Strings
extension Transaction {
    var typeString: String {
        return type == .sent ? "Sent" : "Received"
    }
    
    var amountString: String {
        return amount.toBitcoin.asString
    }
    
    var weightString: String {
        return "\(weight)"
    }
    
    var sizeString: String {
        return "\(size)"
    }
    
    var freeString: String {
        return fee.toBitcoin.asString
    }
    
    var dateString: String {
        return Transaction.dateFormatter.string(from: date)
    }
    
    var timeString: String {
        return Transaction.timeFormatter.string(from: date)
    }
    
    var dateTimeString: String {
        return "\(dateString)\n\(timeString)"
    }
}

// MARK: Formatters
extension Transaction {
    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy"
        return formatter
    }()
}
