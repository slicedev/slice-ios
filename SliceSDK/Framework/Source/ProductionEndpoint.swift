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
    
    let authorizationPath = "oauth/authorize"
    
    var authorizationURL: NSURL {
        return baseURL.URLByAppendingPathComponent(authorizationPath)
    }
    
    let apiPath = "api"
    let apiVersion = "v1"
    
    var apiURL: NSURL {
        let path = apiPath.stringByAppendingPathComponent(apiVersion)
        return baseURL.URLByAppendingPathComponent(path)
    }
}
