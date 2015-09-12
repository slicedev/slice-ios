//
//  Networking.swift
//  SliceSDK
//

import Foundation
import Alamofire

public typealias JSONDictionary = [String : AnyObject]
public typealias JSONResult = ([JSONDictionary]?, NSError?) -> ()

class NetworkManager: NSObject {
    
    private let internalManager: Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        let manager = Manager(configuration: configuration)
        return manager
    } ()
    
    func requestJSON(request: NetworkRequest, result: JSONResult?) {
        internalManager.request(request).responseJSON { (_, _, JSON, error) in
            let resources = self.processResponse(JSON)
            result?(resources, error)
        }
    }
    
    func processResponse(JSON: AnyObject?) -> [JSONDictionary]? {
        if let dictionary = JSON as? [String : AnyObject] {
            return dictionary["result"] as? [JSONDictionary]
        }
        return nil
    }
}

struct NetworkRequest: URLRequestConvertible {
    
    let method: Alamofire.Method
    let URL: NSURL
    private var queryParameters: [String : AnyObject]?
    private var bodyParameters: [String : AnyObject]?
    private var authorizationToken: String?
    
    init(method: Alamofire.Method, URL: NSURL, queryParameters: [String : AnyObject]?, bodyParameters: [String : AnyObject]?, authorizationToken: String?) {
        self.method = method
        self.URL = URL
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.authorizationToken = authorizationToken
    }
    
    var URLRequest: NSURLRequest {
        var request = NSMutableURLRequest(URL: URL)
        
        if let queryParameters = queryParameters {
            let encoding = Alamofire.ParameterEncoding.URL
            var (encodedRequest, _) = encoding.encode(request, parameters: queryParameters)
            request = encodedRequest.mutableCopy() as! NSMutableURLRequest
        }
        
        if let bodyParameters = bodyParameters {
            let encoding = Alamofire.ParameterEncoding.JSON
            var (encodedRequest, _) = encoding.encode(request, parameters: bodyParameters)
            request = encodedRequest.mutableCopy() as! NSMutableURLRequest
        }
        
        if let authorizationToken = authorizationToken {
            let bearerToken = String(format: "Bearer %@", authorizationToken)
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
    
        request.HTTPMethod = method.rawValue // this must come after encoding for Alamofire to work
        return request
    }
}
