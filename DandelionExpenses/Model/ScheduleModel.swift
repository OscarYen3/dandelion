//
//  ScheduleModel.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import Foundation

class Schedule: Codable{
    var scheduleCode : Int
    var date : Date
    var event : String
    var note : String
    
    init() {
        self.scheduleCode = 0
        self.date = Date()
        self.event = ""
        self.note = ""
       
    }
}
