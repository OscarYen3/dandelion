//
//  DeatilProfile.swift
//  DandelionExpenses
//
//  Created by Oscar on 2021/12/12.
//

import Foundation

class DeatilProfile: Codable {
    
    var userid : String
    var name : String
    var category: String
    var use: String
    var amount: Int
    var date: Date
    var userCode: Int
    var whos:[String]
    
   
    init() {
        self.userid = ""
        self.name = ""
        self.category = ""
        self.use = ""
        self.amount = 0
        self.date = Date()
        self.userCode = 0
        self.whos = []
    }
    
    init(_ obj: DeatilDB) {
        self.userid = obj.userid ?? ""
        self.name = obj.name ?? ""
        self.category = obj.category ?? ""
        self.use = obj.use ?? ""
        self.amount = Int(obj.amount)
        self.date = obj.date ?? Date()
        self.userCode = Int(obj.userCode)
        self.whos = DeatilProfile.convertWhosData(szJson: obj.whos ?? "") ?? []
        
    }
    
    init(_ obj: DeatilProfile) {
        self.userid = obj.userid
        self.name = obj.name
        self.category = obj.category
        self.use = obj.use
        self.amount = obj.amount
        self.date = obj.date
        self.userCode = obj.userCode
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
