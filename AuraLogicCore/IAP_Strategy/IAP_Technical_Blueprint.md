# IAP Technical Blueprint: Aura Logic Full Unlock

## 1. Product Definition
- **Product ID:** `com.logicandchill.auralogic.fullunlock`
- **Product Type:** Non-Consumable
- **Scope:** Unlocks all current and future levels across all difficulties (Easy, Medium, Hard, Insane).

## 2. StoreKit 2 Implementation (`StoreManager.swift`)

The implementation uses the modern `StoreKit 2` asynchronous API.

### Key Components:
- **Product Loading:** Fetch the product information from the App Store.
- **Purchase Handling:** Execute the purchase and verify the JWS (JSON Web Signature) transaction.
- **Transaction Listener:** A background task that listens for updates (e.g., purchases made on other devices, renewals).
- **Verification:** Securely verifying that the transaction is legitimate using StoreKit's built-in verification.

```swift
import StoreKit

class StoreManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private var transactionListener: Task<Void, Error>?

    init() {
        // Start listening for transactions as soon as the manager is initialized
        transactionListener = listenForTransactions()
        
        Task {
            await fetchProducts()
            await updateCustomerProductStatus()
        }
    }

    @MainActor
    func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["com.logicandchill.auralogic.fullunlock"])
            self.products = storeProducts
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }

    func purchase() async throws -> Transaction? {
        guard let product = products.first else { return nil }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                // Persist the unlock status locally
                IAPPersistence.shared.setFullUnlock(true)
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                }
            }
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
```

## 3. Persistence Logic (Offline-First)

To ensure the user can play offline after purchasing, we use a hybrid approach:
1.  **Keychain (Primary):** Stores the "isUnlocked" flag securely. This persists even if the app is deleted and reinstalled.
2.  **Local Cache (UserDefaults/In-Memory):** For fast synchronous checks during level loading.

### `IAPPersistence.swift`

```swift
import Foundation
import Security

struct IAPPersistence {
    static let shared = IAPPersistence()
    private let unlockKey = "com.logicandchill.auralogic.full_access"

    func isFullUnlockPurchased() -> Bool {
        // Check Keychain first for security and persistence
        return getBoolFromKeychain(key: unlockKey)
    }

    func setFullUnlock(_ status: Bool) {
        saveBoolToKeychain(key: unlockKey, value: status)
    }

    // Standard Keychain Wrappers
    private func saveBoolToKeychain(key: String, value: Bool) {
        let data = value ? "true".data(using: .utf8)! : "false".data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private func getBoolFromKeychain(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let str = String(data: data, encoding: .utf8) {
            return str == "true"
        }
        return false
    }
}
```

## 4. Business Logic (Level Access)
```swift
func canAccessLevel(difficulty: Difficulty, index: Int) -> Bool {
    if IAPPersistence.shared.isFullUnlockPurchased() {
        return true
    }
    
    // Freemium rules: First 10 Easy and 10 Medium are free
    if difficulty == .easy && index < 10 { return true }
    if difficulty == .medium && index < 10 { return true }
    
    return false
}
```
