//
//  JsonExtension.swift
//  Runner
//
//  Created by Jacob Welin - Wejeo on 10/09/2022.
//

import Foundation
extension Collection where Iterator.Element == [AnyHashable : Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}


extension Dictionary {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let val = self as? [String:AnyObject],
           let dat = try? JSONSerialization.data(withJSONObject: val, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
