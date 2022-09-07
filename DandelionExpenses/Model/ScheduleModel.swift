//
//  ScheduleModel.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import Foundation

class Schedule: Codable{
    var event : String
    var time : Date
    
    init() {
        self.event = ""
        self.time = Date()
       
    }
}
