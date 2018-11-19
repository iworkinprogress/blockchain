# Blockchain
Playing around with Blockchain API

# Synopsis

View a list of wallet balance and transactions at a specified Bitcoin address.

# Installation

Just open the Xcode project and build. No 3rd party libraries are used.

# Description

Transaction data is loaded from a GET request to the Blockchain API. This JSON is decoded using two structs:

`Wallet`
- Current balance
- List of `Transactions`

`Transaction`
- Detailed information about a transaction (amount, time, hash, etc.)

Transactions are displayed by `TransactionsViewController`. It controls a `UICollectionView` that can switch between a list and detail layout.

`List`
- Vertical scrolling list of transactions
- Red rows are sent Bitcoins
- Green rows are received Bitcoins
- Tapping a row will display more details about the transaction

`Detail`
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
