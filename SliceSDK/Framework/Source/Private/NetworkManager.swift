//
//  Networking.swift
//  SliceSDK
//

import Foundation
import Alamofire

public typealias JSONArray = [JSONDictionary]
public typealias JSONDictionary = [String : AnyObject]
public typealias JSONResult = (AnyObject?, NSError?) -> ()

class NetworkManager: NSObject {
    
    private let internalManager: Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        let manager = Manager(configuration: configuration)
        return manager
    } ()
    
    func requestJSON(request: NetworkRequest, result: JSONResult?) {
        internalManager.request(request).responseJSON { (_, _, JSON, error) in
            let response: AnyObject? = self.processResponse(JSON)
            result?(response, error)
        }
    }
    
    func processResponse(JSON: AnyObject?) -> AnyObject? {
        if let dictionary = JSON as? JSONDictionary {
            if let array = dictionary["result"] as? [JSONDictionary] {
                return array
            } else {
                return dictionary
            }
        } else if let array = JSON as? JSONArray {
            return array
        } else {
            return nil
        }
    }
}

struct NetworkRequest: URLRequestConvertible {
    
    let method: Alamofire.Method
    let URL: NSURL
    private var queryParameters: [String : AnyObject]?
    private var bodyParameters: [String : AnyObject]?
    private var accessToken: String?
    
    init(method: Alamofire.Method, URL: NSURL, queryParameters: [String : AnyObject]?, bodyParameters: [String : AnyObject]?, accessToken: String?) {
        self.method = method
        self.URL = URL
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.accessToken = accessToken
    }
    
    var URLRequest: NSURLRequest {
        var request = NSMutableURLRequest(URL: URL)
        
        request.HTTPMethod = method.rawValue // this must come after encoding for Alamofire to work
        
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
        
        if let accessToken = accessToken {
            let bearerToken = String(format: "Bearer %@", accessToken)
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
