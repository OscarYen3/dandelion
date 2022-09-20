//
//  ScheduleModel.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import Foundation

class Schedule: Codable{
    var scheduleId: String
    var scheduleCode: Int
    var date: Date
    var event: String
    var note: String
    var sort: Int
    
    init() {
        self.scheduleId = ""
        self.scheduleCode = 0
        self.date = Date()
        self.event = ""
        self.note = ""
        self.sort = 0
       
    }
    
    init(_ obj: ScheduleDB) {
        self.scheduleId = obj.scheduleId ?? ""
        self.scheduleCode = Int(obj.scheduleCode)
        self.date = obj.date ?? Date()
        self.event = obj.event ?? ""
        self.note = obj.note ?? ""
        self.sort = Int(obj.sort)
        
    }
    
    init(_ obj: Schedule) {
        self.scheduleId = obj.scheduleId
        self.scheduleCode = obj.scheduleCode
        self.date = obj.date
        self.event = obj.event
        self.note = obj.note
        self.sort = obj.sort
        
    }
    
    static  func convertScheduleData( szJson: String) -> [String]? {
        var lstUserData : [String] = []
        if let data = szJson.data(using: .utf8) {
            let oProfileInfo = try? JSONDecoder().decode([String].self, from: data )
            lstUserData = oProfileInfo ?? []
        }
        return lstUserData
    }
}

