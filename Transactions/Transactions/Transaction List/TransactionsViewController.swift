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
        case list(Wallet)
        case detail(Wallet, Transaction)
        case error(APIError)
    }
    
    var state: State = .loading {
        didSet(oldValue) {
            switch(oldValue) {
            case .error, .loading:
                updateLayout(animated: false)
            case .list, .detail:
                updateLayout(animated: true)
            }
            collectionView.reloadData()
        }
    }
    
    // MARK: Views
    lazy var closeButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close button title"), style: .plain, target: self, action: #selector(zoomOut))
        barButton.tintColor = .white
        return barButton
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = nil
        setupCollectionView()
        loadWallet()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let page = currentPage()
        coordinator.animate(alongsideTransition: { (context) in
            self.updateItemSizes()
            // Reposition contentOffset so the cell on screen remains on screen
            if(self.collectionView.collectionViewLayout == self.listLayout) {
                // Not working well in list mode. But list mode seems to work fine as is
//                self.collectionView.contentOffset = CGPoint(x: 0, y: page * size.height)
            } else {
                self.collectionView.setContentOffset(CGPoint(x: page * size.width, y: 0), animated: true)
            }
        }) { (context) in
        }
    }
    
    func currentPage() -> CGFloat {
        if(collectionView.collectionViewLayout == listLayout) {
            return collectionView.contentOffset.y / listLayout.itemSize.height
        } else {
            return collectionView.contentOffset.x / fullScreenLayout.itemSize.width
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        updateItemSizes()
    }
    
    // MARK: Configuration
    // Register all collection view cells
    func setupCollectionView() {
        collectionView.register(
            UINib(nibName: TransactionCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier:  TransactionCollectionViewCell.cellIdentifier)
        collectionView.register(
            UINib(nibName: LoadingCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: LoadingCollectionViewCell.cellIdentifier)
        collectionView.register(
            UINib(nibName: ErrorCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier:  ErrorCollectionViewCell.cellIdentifier)
        updateLayout(animated: false)
    }
    
    // Attempt to load a wallet from BlockchainAPI
    // - Will update state with either a success or failure
    func loadWallet() {
        BlockchainAPI.getTransactions(for: walletAddress) { (result) in
            DispatchQueue.main.async {
                switch(result) {
                case .success(let wallet):
                    self.state = .list(wallet)
                    self.title = wallet.balanceString
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
    
    //MARK: Actions
    
    func zoomIn(to transaction: Transaction) {
        guard case .list(let wallet) = state else { return }
        navigationItem.rightBarButtonItem = closeButton
        collectionView.isPagingEnabled = true
        state = .detail(wallet, transaction)
    }
    
    @objc func zoomOut() {
        guard case .detail(let wallet, _) = state else { return }
        navigationItem.rightBarButtonItem = nil
        collectionView.isPagingEnabled = false
        state = .list(wallet)
    }
    
    //MARK: Layouts
    
    func updateLayout(animated: Bool) {
        let layout: UICollectionViewFlowLayout
        switch(state) {
        case .error, .loading:
            layout = fullScreenLayout
            navigationItem.largeTitleDisplayMode = .always
            updateFullScreenItemSize()
        case .detail:
            layout = fullScreenLayout
            navigationItem.largeTitleDisplayMode = .never
            updateFullScreenItemSize()
        case .list(_):
            layout = listLayout
            navigationItem.largeTitleDisplayMode = .always
            updateListItemSize()
        }
        collectionView.setCollectionViewLayout(layout, animated: animated)
        for cell in collectionView.visibleCells {
            if let transactionCell = cell as? TransactionCollectionViewCell {
                transactionCell.presentation = layout == listLayout ? .list : .detail
            }
        }
    }
    
    func updateItemSizes() {
        updateFullScreenItemSize()
        updateListItemSize()
    }
    
    func updateFullScreenItemSize() {
        fullScreenLayout.itemSize = CGSize(
            width: view.bounds.size.width,
            height:view.safeAreaLayoutGuide.layoutFrame.size.height)
        fullScreenLayout.invalidateLayout()
    }
    
    func updateListItemSize() {
        listLayout.itemSize = CGSize(width: view.bounds.size.width, height:transactionCellHeight)
        listLayout.invalidateLayout()
    }
    
    lazy var fullScreenLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.bounds.size.width,
            height:view.safeAreaLayoutGuide.layoutFrame.size.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var listLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.bounds.size.width,
            height:transactionCellHeight)
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
        case .list(let wallet), .detail(let wallet, _):
            return wallet.transactions.count
        case .error, .loading:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(state) {
        case .list(let wallet), .detail(let wallet, _):
            let transactionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.cellIdentifier, for: indexPath) as! TransactionCollectionViewCell
            transactionCell.transaction = wallet.transactions[indexPath.item]
            transactionCell.presentation = collectionView.collectionViewLayout == listLayout ? .list : .detail
            return transactionCell
        case .loading:
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.cellIdentifier, for: indexPath)
        case .error:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCollectionViewCell.cellIdentifier, for: indexPath)
        }
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(state) {
        case .list(let wallet):
            guard let transaction = wallet.transaction(at: indexPath.row) else { return }
            zoomIn(to: transaction)
            if let cell = collectionView.cellForItem(at: indexPath) {
                // Make the selected cell the top layer
                // This improves animation clarity
                // Better solution might be to create custom Flow layouts that have more control
                // Over the zIndex layout attributes
                cell.superview?.bringSubviewToFront(cell)
            }
        case .detail, .loading, .error:
            break
        }
        
    }
}
