//
//  SliceClient.swift
//  SliceSDK
//

import Foundation
import UIKit

import KeychainAccess

public struct SliceSettings {
    
    internal let clientID: String
    internal let clientSecret: String
    
    public init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}

public typealias AuthorizationResult = (String?, NSError?) -> ()

public class SliceClient {

    private let networkManager = NetworkManager()
    private let serverEndpoint = ProductionEndpoint()
    private let keychain: Keychain
    private let settings: SliceSettings
    private let URLScheme: String
    private let redirectURI: String
    
    public init(settings: SliceSettings) {
        self.settings = settings
        self.URLScheme = "com.slice.developer." + settings.clientID
        self.redirectURI = self.URLScheme + "://auth"
        self.keychain = Keychain(service: self.URLScheme)
    }
    
    // MARK: Authorization
    
    private var authorizationURL: NSURL {
        let parameters = [ "client_id" : settings.clientID ,
                           "response_type" : "code" ,
                           "redirect_uri" : redirectURI ]
        let baseURL = serverEndpoint.oauthURL.URLByAppendingPathComponent("authorize")
        let authorizationURL = baseURL.URLByAppendingQueryParameters(parameters, encode: false)!
        return authorizationURL
    }
    
    private var authorizationResult: AuthorizationResult?
    
    public func authorize(application: UIApplication, result: AuthorizationResult?) {
        let authorizationURL = self.authorizationURL
        if application.canOpenURL(authorizationURL) {
            authorizationResult = result
            application.openURL(authorizationURL)
        }
    }
    
    public func unauthorize() {
        currentAccessToken = nil
    }
    
    // MARK: Open URL

    public func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var handled = false
        if let scheme = url.scheme {
            if scheme == URLScheme {
                handled = true
                if let queryParameters = url.queryParameters,
                   let code = queryParameters["code"] {
                    self.authorizeCode(code)
                }
            }
        }
        return handled
    }
    
    // MARK: Access Token
    
    private func authorizeCode(code: String) {
        let codeURL = serverEndpoint.oauthURL.URLByAppendingPathComponent("token")
        let parameters = [ "client_id" : settings.clientID ,
                           "client_secret": settings.clientSecret ,
                           "grant_type" : "authorization_code" ,
                           "code" : code ,
                           "redirect_uri" : redirectURI ]
        let codeRequest = NetworkRequest(method: .POST, URL: codeURL, queryParameters: parameters, bodyParameters: nil, accessToken: nil)
        networkManager.requestJSON(codeRequest) { (response, error) in
            if let dictionary = response as? JSONDictionary,
               let accessToken = dictionary["access_token"] as? String {
                self.currentAccessToken = accessToken
                self.authorizationResult?(accessToken, nil)
                self.authorizationResult = nil
            }
        }
    }
    
    public private(set) var currentAccessToken: String? {
        get {
            return keychain["currentAccessToken"]
        }
        set {
            keychain["currentAccessToken"] = newValue
        }
    }
    
    // MARK: Resources
    
    public func resources(name: String, parameters: [String : AnyObject]?, result: JSONResult?) {
        if let accessToken = currentAccessToken {
            let resourcesURL = serverEndpoint.apiURL.URLByAppendingPathComponent(name)
            let resourceRequest = NetworkRequest(method: .GET, URL: resourcesURL, queryParameters: parameters, bodyParameters: nil, accessToken: accessToken)
            networkManager.requestJSON(resourceRequest, result: result)
        }
    }
}
