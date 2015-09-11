//
//  AccountStore.swift
//  SliceSDK
//

import Foundation
import KeychainAccess

public class AccountStore : NSObject {
    
    static let sharedStore = AccountStore()
    
    private static let keychainService = "com.slice.slicesdk.account"
    
    private var accountKeychain: Keychain {
        return Keychain(service: AccountStore.keychainService)
    }
    
    private static let currentAccountIdentifierKey = "currentAccountIdentifier"
    
    public var currentAccount: Account? {
        get {
            var account: Account?
            if let email = accountKeychain[AccountStore.currentAccountIdentifierKey] {
                account = loadAccount(email)
            }
            return account
        }
        set(newAccount) {
            if let account = newAccount {
                saveAccount(account)
                accountKeychain[AccountStore.currentAccountIdentifierKey] = account.identifier
            } else {
                if let account = currentAccount {
                    removeAccount(account)
                }
                accountKeychain[AccountStore.currentAccountIdentifierKey] = nil
            }
        }
    }
    
    public func loadAccount(email: String) -> Account? {
        let key = email
        var account: Account?
        if let data = accountKeychain[data: key] {
            account = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Account
        }
        return account
    }
    
    public func saveAccount(account: Account) {
        let key = account.identifier
        let data = NSKeyedArchiver.archivedDataWithRootObject(account)
        accountKeychain[data: key] = data
    }
    
    public func removeAccount(account: Account) {
        let key = account.identifier
        accountKeychain[key] = nil
    }
}
