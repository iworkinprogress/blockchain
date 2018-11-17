//
//  TransactionsViewController.swift
//  Transactions
//
//  Created by Steven Baughman on 11/16/18.
//  Copyright © 2018 Steven Baughman. All rights reserved.
//

import UIKit

private let walletAddress = "xpub6CfLQa8fLgtouvLxrb8EtvjbXfoC1yqzH6YbTJw4dP7srt523AhcMV8Uh4K3TWSHz9oDWmn9MuJogzdGU3ncxkBsAC9wFBLmFrWT9Ek81kQ"

private let transactionCellHeight: CGFloat = 100.0

class TransactionsViewController: UICollectionViewController {
    
    enum State {
        case loading
        case loaded(Wallet)
        case error(APIError)
    }
    
    var state: State = .loading {
        didSet {
            self.updateLayout()
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.loadWallet()
    }
    
    // Register all collection view cells
    func setupCollectionView() {
        self.collectionView.register(
            UINib(nibName: TransactionCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier:  TransactionCollectionViewCell.cellIdentifier)
        self.collectionView.register(
            UINib(nibName: LoadingCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: LoadingCollectionViewCell.cellIdentifier)
        self.collectionView.register(
            UINib(nibName: ErrorCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier:  ErrorCollectionViewCell.cellIdentifier)
        self.updateLayout()
    }
    
    // Attempt to load a wallet from BlockchainAPI
    // - Will update state with either a success or failure
    func loadWallet() {
        BlockchainAPI.getTransactions(for: walletAddress) { (result) in
            DispatchQueue.main.async {
                switch(result) {
                case .success(let wallet):
                    self.state = .loaded(wallet)
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
    
    func updateLayout() {
        switch(state) {
        case .error:
            self.collectionView.collectionViewLayout = self.fullScreenLayout
        case .loading, .loaded(_):
            self.collectionView.collectionViewLayout = self.listLayout
        }
    }
    
    //MARK: - Layouts
    
    lazy var fullScreenLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var listLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:self.view.bounds.size.width, height:transactionCellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        return layout
    }()
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(state) {
        case .loading:
            // simulate infinite scrolling while loading
            return 99999
        case .loaded(let wallet):
            return wallet.transactions.count
        case .error:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(state) {
        case .loaded(let wallet):
            let transactionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.cellIdentifier, for: indexPath) as! TransactionCollectionViewCell
            transactionCell.transaction = wallet.transactions[indexPath.row]
            return transactionCell
        case .loading:
            let transactionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.cellIdentifier, for: indexPath) as! TransactionCollectionViewCell
            transactionCell.transaction = nil
            return transactionCell
        case .error:
            let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCollectionViewCell.cellIdentifier, for: indexPath) as! ErrorCollectionViewCell
            return errorCell
        }
    }
}
