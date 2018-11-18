//
//  Bitcoins.swift
//  Transactions
//
//  Created by Steven Baughman on 11/17/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import Foundation

public typealias Satoshi = Int64
public typealias Bitcoin =  Double

// Convert satoshis to Bitcoins
extension Satoshi {
    var toBitcoin: Bitcoin {
        return Double(self) * 1e-8
    }
}

extension Bitcoin {
    var asString: String {
        return "\(abs(self).avoidNotation) BTC"
    }
}

extension Formatter {
    static let avoidNotation: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

extension FloatingPoint {
    var avoidNotation: String {
        return Formatter.avoidNotation.string(for: self) ?? ""
    }
}
