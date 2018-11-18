//
//  CollectionViewCell.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import UIKit

protocol ErrorCellDelegate {
    func retryLoadingData()
}

class ErrorCollectionViewCell: UICollectionViewCell {
    
    static let nibName = "ErrorCollectionViewCell"
    static let cellIdentifier = "ErrorCellIdentifier"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    var delegate: ErrorCellDelegate?
    
    var error: APIError? {
        didSet {
            guard let error = error else { return }
            let message: String
            switch(error) {
            case .loadData:
                message = "Unable to load data"
            case .parseJson(let error):
                message = error.localizedDescription
            case .unknownError(let error):
                message = error.localizedDescription
            }
            label.text = message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.tintColor = Colors.red
    }
    
    @IBAction func retryLoadingData() {
        delegate?.retryLoadingData()
    }
}
