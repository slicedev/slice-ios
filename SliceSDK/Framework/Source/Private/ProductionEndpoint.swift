//
//  ProductionEndpoint.swift
//  SliceSDK
//

import Foundation

struct ProductionEndpoint: ServerEndpoint {

    let scheme = "https"
    let host = "api.slice.com"
    
    var baseURL: NSURL {
        return NSURL(scheme: scheme, host: host, path: "/")!
    }
    
    let oauthPath = "oauth"
    
    var oauthURL: NSURL {
        return baseURL.URLByAppendingPathComponent(oauthPath)
    }
    
    let apiPath = "api"
    let apiVersion = "v1"
    
    var apiURL: NSURL {
        let path = apiPath.stringByAppendingPathComponent(apiVersion)
        return baseURL.URLByAppendingPathComponent(path)
    }
}
