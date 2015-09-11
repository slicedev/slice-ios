//
//  AccountCoder.swift
//  Unroll
//

import Foundation

class AccountCoder: NSObject, NSSecureCoding {
    
    let account: Account
    
    init(account: Account) {
        self.account = account
    }
    
    static func supportsSecureCoding() -> Bool {
        return true
    }
    
    static let accountIDKey = "accountID"
    static let emailKey = "email"
    static let providerKey = "provider"
    static let tokenKey = "token"
    
    required init(coder aDecoder: NSCoder) {
        let accountID = aDecoder.decodeObjectOfClass(NSString.classForCoder(), forKey: AccountCoder.accountIDKey) as! String
        let email = aDecoder.decodeObjectOfClass(NSString.classForCoder(), forKey: AccountCoder.emailKey) as! String
        let providerString = aDecoder.decodeObjectOfClass(NSString.classForCoder(), forKey: AccountCoder.providerKey) as! String
        let provider = ServiceProvider(rawValue: providerString)!
        let token = aDecoder.decodeObjectOfClass(NSString.classForCoder(), forKey: AccountCoder.tokenKey) as! String
        account = Account(accountID: accountID, email: email, provider: provider, token: token)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(account.accountID, forKey: AccountCoder.accountIDKey)
        aCoder.encodeObject(account.email, forKey: AccountCoder.emailKey)
        let providerString = account.provider.rawValue
        aCoder.encodeObject(providerString, forKey: AccountCoder.providerKey)
        aCoder.encodeObject(account.token, forKey: AccountCoder.tokenKey)
    }
}
