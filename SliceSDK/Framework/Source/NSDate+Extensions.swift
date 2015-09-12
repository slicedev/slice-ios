//
//  NSDate+Extensions.swift
//  SliceSDK
//

import Foundation

class DateHelper {
    static var dateFormatters = [String: NSDateFormatter]()
}

public extension NSDate {
    
    class func dateFormatterWithFormat(format: String) -> NSDateFormatter {
        var dateFormatter = DateHelper.dateFormatters[format]
        if dateFormatter == nil {
            dateFormatter = NSDateFormatter()
            dateFormatter!.dateFormat = format
            DateHelper.dateFormatters[format] = dateFormatter!
        }
        return dateFormatter!
    }
    
    // String
    public convenience init(string: String, format: String) {
        if let date = NSDate.dateFormatterWithFormat(format).dateFromString(string) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            assertionFailure("Invalid date string: \(string), format: \(format)")
            self.init()
        }
    }
    
    public func stringValue(format: String) -> String {
        return NSDate.dateFormatterWithFormat(format).stringFromDate(self)
    }
    
    // Milliseconds
    public convenience init(millisecondsSince1970 milliseconds: Int64) {
        let interval = Double(milliseconds) / 1000.0
        self.init(timeIntervalSince1970: interval)
    }
    
    public var millisecondsSince1970: Int64 {
        return Int64(timeIntervalSince1970 * 1000.0)
    }
    
    // ISO Date Time
    public static var ISODateTimeFormat: String {
        return "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    public convenience init?(ISODateTimeString string: String) {
        self.init(string: string, format: NSDate.ISODateTimeFormat)
    }
    
    public var ISODateTimeString: String {
        return stringValue(NSDate.ISODateTimeFormat)
    }
    
    // ISO Date
    public static var ISODateFormat: String {
        return "yyyy-MM-dd"
    }
    
    public convenience init?(ISODateString string: String) {
        self.init(string: string, format: NSDate.ISODateFormat)
    }
    
    public var ISODateString: String {
        return stringValue(NSDate.ISODateFormat)
    }
}
