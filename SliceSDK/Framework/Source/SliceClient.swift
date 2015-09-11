//
//  SliceClient.swift
//  SliceSDK
//

import Foundation
import UIKit
import Alamofire

struct SliceSettings {
    
    internal let clientID: String
    internal let clientSecret: String
    
    init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}

typealias AuthorizationResult = (String?, NSError?) -> ()

class SliceClient {

    private let networkManager = NetworkManager()
    private let serverEndpoint: ServerEndpoint
    private let settings: SliceSettings
    private let redirectURI: String
    
    init(settings: SliceSettings) {
        self.serverEndpoint = ProductionEndpoint()
        self.settings = settings
        self.redirectURI = "slice." + settings.clientID
    }
    
    var authorizationRequest: NSURLRequest {
        let parameters = [ "client_id" : settings.clientID ,
                           "response_type" : "code" ,
                           "redirect_uri" : redirectURI ]
        let authorizationURL = serverEndpoint.authorizationURL
        let request = NSURLRequest(URL: authorizationURL)
        let encoding = Alamofire.ParameterEncoding.URL
        var (encodedRequest, _) = encoding.encode(request, parameters: parameters)
        return encodedRequest
    }
    
    var authorizationViewController: UIViewController {
        let webViewController = WebViewController()
        webViewController.webRequest = authorizationRequest
        return webViewController
    }
    
    private var authorizationResult: AuthorizationResult?
    
    func authorizationResult(result: AuthorizationResult) {
        authorizationResult = result
    }
    
    // MARK: Resources
    
    func resources(name: String, parameters: [String : AnyObject]?, result: JSONResult?) {
        let resourcesURL = serverEndpoint.apiURL.URLByAppendingPathComponent(name)
        let resourceRequest = NetworkRequest(method: .GET, URL: resourcesURL, queryParameters: parameters, bodyParameters: nil, authorizationToken: "")
        networkManager.requestJSON(resourceRequest, result: result)
    }
    
    // MARK: Open URL
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var handled = false
        if let openURLString = url.absoluteString {
            if openURLString == redirectURI {
                authorizationResult?(nil, nil)
                handled = true
            }
        }
        return handled
    }
}

// sign up?
