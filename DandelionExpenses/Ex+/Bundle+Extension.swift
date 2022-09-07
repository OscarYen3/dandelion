//
//  Bundle+Extension.swift
//  Marswin
//
//  Created by darwinhu on 2020/2/6.
//  Copyright © 2020 darwinhu. All rights reserved.
//

import Foundation

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
