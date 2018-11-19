//
//  BlockchainAPI.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknownError(Error)
    case loadData
    case parseJson(Error)
}

struct BlockchainAPI {
    
    enum Result {
        case success(Wallet)
        case failure(APIError)
    }
    
    // Get the Wallet at specified address
    // - Wallet contains a current balance and a list of Transactions
    static func getWallet(for address: String, completion: @escaping (Result)->Void) {
        guard let url = URL(string: "https://blockchain.info/multiaddr?n=100&active=" + address) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unknownError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.loadData))
                return
            }
            
            do {
                let wallet = try JSONDecoder().decode(Wallet.self, from: data)
                completion(.success(wallet))
            } catch let error {
                completion(.failure(.parseJson(error)))
            }
        }
        task.resume()
    }
}
