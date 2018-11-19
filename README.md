# Blockchain Transactions

View a Bitcoin wallet balance and transactions for a specified address.

# Installation

Open the Xcode project and build. No 3rd party libraries are used.

# Description

Transaction data is loaded from a GET request to the [Blockchain API](https://www.blockchain.com/api). This JSON is decoded using two structs:

`Wallet`
- Current balance
- List of `Transactions`

`Transaction`
- Detailed information about a transaction (amount, time, hash, etc.)

Transactions are displayed in a `TransactionCollectionViewCell` by `TransactionsViewController`. 

`TransactionsViewController`
- Can present transactions in a list or detail layout
- Supports Landscape and Portrait rotation 

`List Layout`
- Vertical scrolling list of transactions
- Red rows are sent Bitcoins
- Green rows are received Bitcoins
- Tapping a row will display more details about the transaction

`Detail Layout`
- Horizontal scrolling list of transactions
- Additional details about the transaction (hash, fee, weight, size)
- Tapping `Close` in navigation bar returns to the `list` view

Additionally, the `TransactionViewController` can display two additional types of cells:

`LoadingCollectionViewCell`
- Shows activity indicator when refreshing data

`ErrorCollectionViewCell`
- Shows Error message and retry button enountering an error while loading data

# Screenshots

<img src="/screenshots/list.png" alt="Transaction List" width="400" /> <img src="/screenshots/detail.png" alt="Transaction List" width="400" /> <img src="/screenshots/landscape.png" alt="Transaction List" width="800" /> <img src="/screenshots/error.png" alt="Transaction List" width="400" /> <img src="/screenshots/loading.png" alt="Transaction List" width="400" />


# Todo

Rotation
- Landscape detail view overlaps safe area

Animations
- Animations between list and detial could be clearer

Gestures
- Pinch to zoom out of detail view

Price
- Display transactions in USD and BTC
