
import Foundation
import StoreKit
import Pushwoosh
import Adjust

protocol GTA_IAPManagerProtocol: AnyObject {
    func gta_infoAlert(title: String, message: String)
    func gta_goToTheApp()
    func gta_failed()
}

class GTA_IAPManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    private var inMain: SKProduct?
    private var inUnlockContent: SKProduct?
    private var inUnlockFunc: SKProduct?
    private var inUnlockOther: SKProduct?
    
    static let shared = GTA_IAPManager()
    weak var  transactionsDelegate: GTA_IAPManagerProtocol?
    
    public var  localizablePrice = "$4.99"
    public var productBuy : gta_PremiumMainControllerStyle = .mainProduct
    public var productBought: [gta_PremiumMainControllerStyle] = []
    
    private var mainProduct = GTA_Configurations.mainSubscriptionID
    private var unlockContentProduct = GTA_Configurations.unlockContentSubscriptionID
    private var unlockFuncProduct = GTA_Configurations.unlockFuncSubscriptionID
    private var unlockOther = GTA_Configurations.unlockerThreeSubscriptionID
    
    private var secretKey = GTA_Configurations.subscriptionSharedSecret
    
    private var isRestoreTransaction = true
    private var restoringTransactionProductId: [String] = []
    
    private let iapError      = NSLocalizedString("error_iap", comment: "")
    private let prodIDError   = NSLocalizedString("inval_prod_id", comment: "")
    private let restoreError  = NSLocalizedString("faledRestore", comment: "")
    private let purchaseError = NSLocalizedString("notPurchases", comment: "")
    

    
    
    public func gta_doPurchase() {
        switch productBuy {
        case .mainProduct:
            gta_processPurchase(for: inMain, with: GTA_Configurations.mainSubscriptionID)
        case .unlockContentProduct:
            gta_processPurchase(for: inUnlockContent, with: GTA_Configurations.unlockContentSubscriptionID)
        case .unlockFuncProduct:
            gta_processPurchase(for: inUnlockFunc, with: GTA_Configurations.unlockFuncSubscriptionID)
        case .unlockOther:
            gta_processPurchase(for: inUnlockOther, with: GTA_Configurations.unlockerThreeSubscriptionID)
        }
    }
    
    public func gta_loadProductsFunc() {
        SKPaymentQueue.default().add(self)
        let request = SKProductsRequest(productIdentifiers:[mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther])
        request.delegate = self
        request.start()
    }
    

    
    private func gta_getCurrentProduct() -> SKProduct? {
        switch productBuy {
        case .mainProduct:
            return self.inMain
        case .unlockContentProduct:
            return self.inUnlockContent
        case .unlockFuncProduct:
            return self.inUnlockFunc
        case .unlockOther:
            return self.inUnlockOther
        }
    }
    
    public func gta_localizedPrice() -> String {
        guard GTA_NetworkStatusMonitor.shared.isNetworkAvailable else { return localizablePrice }
        switch productBuy {
          case .mainProduct:
            gta_processProductPrice(for: inMain)
          case .unlockContentProduct:
            gta_processProductPrice(for: inUnlockContent)
          case .unlockFuncProduct:
            gta_processProductPrice(for: inUnlockFunc)
        case .unlockOther:
            gta_processProductPrice(for: inUnlockOther)
        }
        return localizablePrice
    }
    
    private func gta_processPurchase(for product: SKProduct?, with configurationId: String) {
        guard let product = product else {
            self.transactionsDelegate?.gta_infoAlert(title: iapError, message: prodIDError)
            return
        }
        if product.productIdentifier.isEmpty {
            
            self.transactionsDelegate?.gta_infoAlert(title: iapError, message: prodIDError)
        } else if product.productIdentifier == configurationId {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
    
    private func gta_completeRestoredStatusFunc(restoreProductID : String, transaction: SKPaymentTransaction) {
        if restoringTransactionProductId.contains(restoreProductID) { return }
        restoringTransactionProductId.append(restoreProductID)
        
        gta_validateSubscriptionWithCompletionHandler(productIdentifier: restoreProductID) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.restoringTransactionProductId.removeAll {$0 == restoreProductID}
            if result {
                
                if let mainProd = self.inMain, restoreProductID == mainProd.productIdentifier {
                    self.transactionsDelegate?.gta_goToTheApp()
                    gta_trackSubscription(transaction: transaction, product: mainProd)
                    
                }
                else if let firstProd = self.inUnlockFunc, restoreProductID == firstProd.productIdentifier {
                    gta_trackSubscription(transaction: transaction, product: firstProd)
                    
                }
                else if let unlockContent = self.inUnlockContent, restoreProductID == unlockContent.productIdentifier {
                    gta_trackSubscription(transaction: transaction, product: unlockContent)
                    
                }
            } else {
                self.transactionsDelegate?.gta_infoAlert(title: self.restoreError, message: self.purchaseError)
            }
        }
        self.transactionsDelegate?.gta_infoAlert(title: self.restoreError, message: self.purchaseError)
    }
    
    public func gta_doRestore() {
        guard isRestoreTransaction else { return }
        SKPaymentQueue.default().restoreCompletedTransactions()
        isRestoreTransaction = false
    }
    
    public func gta_completeAllTransactionsFunc() {
        // some comment for trash
        let transactions = SKPaymentQueue.default().transactions
        // some comment for trash
        for transaction in transactions {
            // some comment for trash
            let transactionState = transaction.transactionState
            // some comment for trash
            if transactionState == .purchased || transactionState == .restored {
                // some comment for trash
                SKPaymentQueue.default().finishTransaction(transaction)
                // some comment for trash
                
            }
        }
    }
    
    // Ваша собственная функция для проверки подписки.
    public func gta_validateSubscriptionWithCompletionHandler(productIdentifier: String,_ resultExamination: @escaping (Bool) -> Void) {
        SKReceiptRefreshRequest().start()
        
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptUrl) else {
            gta_pushwooshSetSubTag(value: false)
            resultExamination(false)
            return
        }
        
        let receiptDataString = receiptData.base64EncodedString(options: [])
        
        let jsonRequestBody: [String: Any] = [
            "receipt-data": receiptDataString,
            "password": self.secretKey,
            "exclude-old-transactions": true
        ]
        
        let requestData: Data
        do {
            requestData = try JSONSerialization.data(withJSONObject: jsonRequestBody)
        } catch {
            print("Failed to serialize JSON: \(error)")
            gta_pushwooshSetSubTag(value: false)
            resultExamination(false)
            return
        }
#warning("replace to release")
        //#if DEBUG
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        //#else
        //        let url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
        //#endif
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Failed to validate receipt: \(error) IAPManager")
                self.gta_pushwooshSetSubTag(value: false)
                resultExamination(false)
                return
            }
            
            guard let data = data else {
                print("No data received from receipt validation IAPManager")
                self.gta_pushwooshSetSubTag(value: false)
                resultExamination(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let latestReceiptInfo = json["latest_receipt_info"] as? [[String: Any]] {
                    for receipt in latestReceiptInfo {
                        if let receiptProductIdentifier = receipt["product_id"] as? String,
                           receiptProductIdentifier == productIdentifier,
                           let expiresDateMsString = receipt["expires_date_ms"] as? String,
                           let expiresDateMs = Double(expiresDateMsString) {
                            let expiresDate = Date(timeIntervalSince1970: expiresDateMs / 1000)
                            if expiresDate > Date() {
                                DispatchQueue.main.async {
                                    self.gta_pushwooshSetSubTag(value: true)
                                    resultExamination(true)
                                }
                                return
                            }
                        }
                    }
                }
            } catch {
                print("Failed to parse receipt data 🔴: \(error) IAPManager")
            }
            
            DispatchQueue.main.async {
                self.gta_pushwooshSetSubTag(value: false)
                resultExamination(false)
            }
        }
        task.resume()
    }
    
    
    func gta_validateSubscriptions(productIdentifiers: [String], completion: @escaping ([String: Bool]) -> Void) {
        var results = [String: Bool]()
        let dispatchGroup = DispatchGroup()
        
        for productIdentifier in productIdentifiers {
            dispatchGroup.enter()
            gta_validateSubscriptionWithCompletionHandler(productIdentifier: productIdentifier) { isValid in
                results[productIdentifier] = isValid
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Pushwoosh.sharedInstance().sendSKPaymentTransactions(transactions)
        for transaction in transactions {
            if let error = transaction.error as NSError?, error.domain == SKErrorDomain {
                switch error.code {
                case SKError.paymentCancelled.rawValue:
                    print("User cancelled the request IAPManager")
                case SKError.paymentNotAllowed.rawValue, SKError.paymentInvalid.rawValue, SKError.clientInvalid.rawValue, SKError.unknown.rawValue:
                    print("This device is not allowed to make the payment IAPManager")
                default:
                    break
                }
            }
            
            switch transaction.transactionState {
            case .purchased:
                if let product = gta_getCurrentProduct() {
                    if transaction.payment.productIdentifier == product.productIdentifier {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        gta_trackSubscription(transaction: transaction, product: product)
                        transactionsDelegate?.gta_goToTheApp()
                    }
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionsDelegate?.gta_failed()
//                transactionsDelegate?.gta_infoAlert(title: "error", message: "something went wrong")
                print("Failed IAPManager")
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                gta_completeRestoredStatusFunc(restoreProductID: transaction.payment.productIdentifier, transaction: transaction)
                
            case .purchasing, .deferred:
                print("Purchasing IAPManager")
                
            default:
                print("Default IAPManager")
            }
        }
        gta_completeAllTransactionsFunc()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("requesting to product IAPManager")
        
        if let invalidIdentifier = response.invalidProductIdentifiers.first {
            print("Invalid product identifier:", invalidIdentifier , "IAPManager")
        }
        
        guard !response.products.isEmpty else {
            print("No products available IAPManager")
            return
        }
        
        response.products.forEach({ productFromRequest in
            switch productFromRequest.productIdentifier {
            case GTA_Configurations.mainSubscriptionID:
                inMain = productFromRequest
            case GTA_Configurations.unlockContentSubscriptionID:
                inUnlockContent = productFromRequest
            case GTA_Configurations.unlockFuncSubscriptionID:
                inUnlockFunc = productFromRequest
            case GTA_Configurations.unlockerThreeSubscriptionID:
                inUnlockOther = productFromRequest
            default:
                print("error IAPManager")
                return
            }
            print("Found product: \(productFromRequest.productIdentifier) IAPManager")
        })
    }
    
    private func gta_processProductPrice(for product: SKProduct?) {
        guard let product = product else {
            self.localizablePrice = "4.99 $"
            return
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        if let formattedPrice = numberFormatter.string(from: product.price) {
            self.localizablePrice = formattedPrice
        } else {
            self.localizablePrice = "4.99 $"
        }
    }
    
    private func gta_pushwooshSetSubTag(value : Bool) {
        
        var tag = GTA_Configurations.mainSubscriptionPushTag
        
        switch productBuy {
        case .mainProduct:
            print("continue IAPManager")
        case .unlockContentProduct:
            tag = GTA_Configurations.unlockContentSubscriptionPushTag
        case .unlockFuncProduct:
            tag = GTA_Configurations.unlockFuncSubscriptionPushTag
        case .unlockOther:
            tag = GTA_Configurations.unlockerThreeSubscriptionPushTag
        }
        
        Pushwoosh.sharedInstance().setTags([tag: value]) { error in
            if let err = error {
                print(err.localizedDescription)
                print("send tag error IAPManager")
            }
        }
    }
    
    private func gta_trackSubscription(transaction: SKPaymentTransaction, product: SKProduct) {
        if let receiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: receiptURL) {
            
            let price = NSDecimalNumber(decimal: product.price.decimalValue)
            let currency = product.priceLocale.currencyCode ?? "USD"
            let transactionId = transaction.transactionIdentifier ?? ""
            let transactionDate = transaction.transactionDate ?? Date()
            let salesRegion = product.priceLocale.regionCode ?? "US"
            
            if let subscription = ADJSubscription(price: price, currency: currency, transactionId: transactionId, andReceipt: receiptData) {
                subscription.setTransactionDate(transactionDate)
                subscription.setSalesRegion(salesRegion)
                Adjust.trackSubscription(subscription)
            }
        }
    }
}
