//
//  Encodable+Extension.swift
//  Marswin
//
//  Created by TerryTurner on 2020/1/24.
//  Copyright © 2020 darwinhu. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func toJSONString() -> String? {
        if let jsonData = self.toJSONData() {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}
