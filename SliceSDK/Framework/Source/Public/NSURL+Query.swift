//
//  NSURL+Extensions.swift
//  SliceSDK
//

import Foundation

public extension NSURL {

    public static func encodeQueryString(string: String) -> String {
        let characterSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        return string.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
    }
    
    public static func queryString(parameters: [String: String], encode: Bool) -> String {
        
        let results: [String] = map(parameters) { (key, value) in
            let resultKey = encode ? NSURL.encodeQueryString(key) : key
            let resultValue = encode ? NSURL.encodeQueryString(value) : value
            return "\(resultKey)=\(resultValue)"
        }
        return join("&", results)
    }
    
    public func URLByAppendingQueryParameters(parameters: [String: String], encode: Bool) -> NSURL? {
        if let URLString = absoluteString {
            let queryString = NSURL.queryString(parameters, encode: encode)
            let combinedString = URLString + "?" + queryString
            return NSURL(string: combinedString)
        } else {
            return nil
        }
    }
    
    public var queryParameters: [String: String]? {
        if let query = self.query {
            var dictionary = [String: String]()
            for component in query.componentsSeparatedByString("&") {
                var parts = component.componentsSeparatedByString("=")
                if parts.count == 2 {
                    var key = parts[0].stringByRemovingPercentEncoding!
                    var value = parts[1].stringByRemovingPercentEncoding!
                    dictionary[key] = value
                }
            }
            return dictionary
        }
        return nil
	}
}
