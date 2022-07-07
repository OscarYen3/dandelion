//
//  Logger.swift
//  Marswin
//
//  Created by darwinhu on 2019/11/1.
//  Copyright © 2019 darwinhu. All rights reserved.
//

import Foundation

public class Log {
//    public class func debug(_ message:String? = nil, function: String = #function, file: String = #file, line: Int = #line) {
////#if DEBUG
//        let theFileName = (file as NSString).lastPathComponent
//        if let message = message {
//            print("\(theFileName):\(function):\(line): \(message)")
//        } else {
//            print("\(theFileName):\(function):\(line)")
//        }
////#endif
//    }
    static let VERBOSE = false
    
    public class func d<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        var filename = (file as NSString).lastPathComponent
        filename = filename.components(separatedBy: ".")[0]
        
//        let currentDate = Date()
//        let df = DateFormatter()
//        df.dateFormat = "HH:mm:ss.SSS"
        //┌──────────────┬───────────────────────────────────────────────────────────────
        //│ 14:12:27.366 │ MainViewController.PairingDevice_Click(_:) (113)
        //└──────────────┴───────────────────────────────────────────────────────────────
//        print("┌──────────────┬───────────────────────────────────────────────────────────────")
//        print("│ \(df.string(from: currentDate)) │ \(filename).\(function) (\(line))")
//        print("└──────────────┴───────────────────────────────────────────────────────────────")
//        print("  \(object)\n")
        
        print("\(filename) (\(line)) \t\(object)")
    }

    // verbose
    public class func v<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if VERBOSE {
            var filename = (file as NSString).lastPathComponent
            filename = filename.components(separatedBy: ".")[0]
            print("\(filename) (\(line)) \t\(object)")
        }
    }
    
    // verbose
    public class func sys<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if VERBOSE {
            var filename = (file as NSString).lastPathComponent
            filename = filename.components(separatedBy: ".")[0]
            print("*** \(filename) (\(line)) \t\(object)")
        }
    }
    
}
