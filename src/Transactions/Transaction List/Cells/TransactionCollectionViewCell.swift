//
//  TransactionCollectionViewCell
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
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
    @IBOutlet var hashLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var detailContentView: UIView!
    @IBOutlet var horizontalLine: UIView!
    @IBOutlet var verticalLine: UIView!
    
    // Autolayout Constraints
    // Can be used to adjust top padding in list and detail presentations
    // Not currently used
    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!

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
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
    }
    
    func updatePresentation() {
        scrollView.isScrollEnabled = presentation == .detail
        scrollView.isUserInteractionEnabled = presentation == .detail
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
        hashLabel.text = transaction?.hash
        weightLabel.text = transaction?.weightString
        sizeLabel.text = transaction?.sizeString
        feeLabel.text = transaction?.freeString
    }
    
    func updateColors() {
        guard let transaction = self.transaction else {
            backgroundColor = Colors.smoke
            return
        }
        switch(transaction.type) {
        case .sent:
            backgroundColor = Colors.red
        case .received:
            backgroundColor = Colors.green
        }
    }

    //MARK: Lifecycle
    // This is needed to ensure that cells animate between layouts
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutIfNeeded()
    }
}
