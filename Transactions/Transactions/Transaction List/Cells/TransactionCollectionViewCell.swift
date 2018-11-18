//
//  TransactionCollectionViewCell
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Blockchain. All rights reserved.
//

import UIKit

enum TransactionPresentation {
    case list
    case detail
}

private let lineOpacity: CGFloat = 0.25

class TransactionCollectionViewCell: UICollectionViewCell {
    
    static let nibName = "TransactionCollectionViewCell"
    static let cellIdentifier = "TransactionCellIdentifier"
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var sentLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var timeDateLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var detailContentView: UIView!
    @IBOutlet var horizontalLine: UIView!
    @IBOutlet var verticalLine: UIView!
    
    // Autolayout Constraints
    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentBackgroundView.layer.shadowColor = UIColor.black.cgColor
    }

    var transaction: Transaction? {
        didSet {
            scrollView.contentOffset = .zero
            updateColors()
            updateLabels()
        }
    }
    
    var presentation: TransactionPresentation = .list {
        didSet {
            updatePresentation()
        }
    }
    
    func updatePresentation() {
        scrollView.isScrollEnabled = presentation == .detail
        scrollView.isUserInteractionEnabled = presentation == .detail
        topSpaceConstraint.constant = presentation == .list ? 25 : 50
        let detailContentAlpha: CGFloat = presentation == .detail ? 1.0 : 0.0
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.detailContentView.alpha = detailContentAlpha
        }
        horizontalLine.alpha = presentation == .list ? lineOpacity : 0.0
        verticalLine.alpha = presentation == .detail ? lineOpacity : 0.0
    }
    
    func updateLabels() {
        sentLabel.text = transaction?.typeString
        amountLabel.text = transaction?.amountString
        timeDateLabel.text = transaction?.dateTimeString
        weightLabel.text = transaction?.weightString
        sizeLabel.text = transaction?.sizeString
        feeLabel.text = transaction?.freeString
    }
    
    func updateColors() {
        guard let transaction = self.transaction else {
            backgroundColor = Colors.background
            return
        }
        switch(transaction.type) {
        case .sent:
            backgroundColor = Colors.sent
        case .received:
            backgroundColor = Colors.received
        }
    }

    //MARK: Lifecycle
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutIfNeeded()
    }
}
