//
//  Account.swift
//  SliceSDK
//

import Foundation

public class Account: NSObject, NSSecureCoding, Equatable {
    
    public let identifier: String
    public let refreshToken: String
    public var accessToken: String = ""
    
    public init(identifier: String, refreshToken: String) {
        self.identifier = identifier
        self.refreshToken = refreshToken
    }
}

public func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs.identifier == rhs.identifier
}
