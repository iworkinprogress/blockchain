//
//  TransactionCollectionViewCell
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {
    
    static let nibName = "TransactionCollectionViewCell"
    static let cellIdentifier = "TransactionCellIdentifier"
    
    @IBOutlet var sentLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var timeDateLabel: UILabel!
    @IBOutlet var contentBackgroundView: UIView!

    var transaction: Transaction? {
        didSet {
            updateColors()
            updateContent()
        }
    }
    
    func updateContent() {
        guard let transaction = self.transaction else {
            sentLabel.text = nil
            amountLabel.text = nil
            timeDateLabel.text = nil
            return
        }
        sentLabel.text = transaction.typeString
        amountLabel.text = transaction.bitcoinString
        timeDateLabel.text = "\(transaction.dateString)\n\(transaction.timeString)"
    }
    
    func updateColors() {
        guard let transaction = self.transaction else {
            contentBackgroundView.backgroundColor = Colors.background
            return
        }
        switch(transaction.type) {
        case .sent:
            contentBackgroundView.backgroundColor = Colors.sent
        case .received:
            contentBackgroundView.backgroundColor = Colors.received
        }
    }
}
