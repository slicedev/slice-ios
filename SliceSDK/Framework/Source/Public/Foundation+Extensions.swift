//
//  Foundation+Extensions.swift
//  SliceSDK
//

import Foundation

public func dispatchMain(delay: Double, block: () -> Void) {
    let nanoDelay = delay * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(nanoDelay))
    dispatch_after(time, dispatch_get_main_queue(), block)
}
