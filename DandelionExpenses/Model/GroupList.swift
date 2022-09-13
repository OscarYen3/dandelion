//
//  GroupList.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/7/29.
//

import Foundation

class GroupList: Codable {
    
    var groupId: String
    var date: Date
    var groupCode: Int
    var whos: [String]
    
    
    init() {
        self.groupId = ""
        self.date = Date()
        self.groupCode = 0
        self.whos = []
    }
    
    init(_ obj: GroupDB) {
        self.groupId = obj.groupId ?? ""
        self.date = obj.date ?? Date()
        self.groupCode = Int(obj.groupCode)
        self.whos = DeatilProfile.convertWhosData(szJson: obj.whos ?? "") ?? []
        
    }
    
    init(_ obj: GroupList) {
        self.groupId = obj.groupId
        self.date = obj.date
        self.groupCode = obj.groupCode
        self.whos = obj.whos
        
    }
    
    static  func convertWhosData( szJson: String) -> [String]? {
        var lstUserData : [String] = []
        if let data = szJson.data(using: .utf8) {
            let oProfileInfo = try? JSONDecoder().decode([String].self, from: data )
            lstUserData = oProfileInfo ?? []
        }
        return lstUserData
    }
}
