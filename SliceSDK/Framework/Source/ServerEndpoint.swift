//
//  ServerEndpoint.swift
//  SliceSDK
//

import Foundation

public protocol ServerEndpoint {

    var baseURL: NSURL { get }
    var authorizationURL: NSURL { get }
    var apiURL: NSURL { get }
}
