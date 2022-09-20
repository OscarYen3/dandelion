//
//  CoreDataDB.swift
//  shindeji
//
//  Created by Oscar on 2021/7/10.
//

import Foundation
import CoreData


//===================================================================================
// MARK: - DeatilProfile
//===================================================================================

//新增資料
func insertObject(_ obj: DeatilProfile) {
    let Data = NSEntityDescription.insertNewObject(forEntityName: "DeatilDB", into: viewContext) as! DeatilDB
    Data.userid = obj.userid
    Data.name = obj.name
    Data.category = obj.category
    Data.use = obj.use
    Data.amount = Int32(obj.amount)
    Data.userCode = Int32(obj.userCode)
    Data.whos = toJSON(obj.whos)
    app.saveContext()
}

 func toJSON(_ obj: [String]) -> String {
    let recordData : [String] = obj
    let jsonData = try! JSONEncoder().encode(recordData)
    let jsonProfileInfo = String(data: jsonData, encoding: .utf8)!
    return jsonProfileInfo
}



//刪除所有資料
func deleteAllObject(_ fertilizerData: [DeatilProfile] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<DeatilDB>(entityName: "DeatilDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
          viewContext.delete(item)
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//刪除資料
func deleteObject(indexPath:IndexPath,_ deatilProfile: [DeatilProfile] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<DeatilDB>(entityName: "DeatilDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.name == deatilProfile[indexPath.row].name {
                viewContext.delete(item)
            }
        }
        
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//更新資料
func updateObject(_ data:DeatilProfile) {
    //更新:將查詢到的結果更新後，再呼叫context.save()儲存
    let request = NSFetchRequest<DeatilDB>(entityName: "DeatilDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.name == data.name {
                item.category = data.category
                item.use = data.use
                item.amount = Int32(data.amount)
            }
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//查詢資料
func selectObject() -> Array<DeatilProfile> {
    var array:[DeatilDB] = []
    var ConvertArray: [DeatilProfile] = []
    let request = NSFetchRequest<DeatilDB>(entityName: "DeatilDB")
    do {
        let results = try viewContext.fetch(request)
        for result in results {
            array.append(result)
        }
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
    
    for i in array {
        ConvertArray.append(DeatilProfile(i))
    }
    
    ConvertArray.sort { $0.userCode > $1.userCode}
    return ConvertArray
    
}


//===================================================================================
// MARK: - Accounts
//===================================================================================


//新增資料
func insertAccount(_ obj: AccountList) {
    let Data = NSEntityDescription.insertNewObject(forEntityName: "AccountDB", into: viewContext) as! AccountDB
    Data.accounts = toJSON(obj.accounts)
    app.saveContext()
}

//刪除資料(全部只有一筆，不用刪除)

//07/04 還用不到
////更新資料
//func updateAccount(_ data:AccountList) {
//    //更新:將查詢到的結果更新後，再呼叫context.save()儲存
//    let request = NSFetchRequest<DeatilDB>(entityName: "AccountDB")
//    do {
//        let results = try viewContext.fetch(request)
//        for item in results {
//            if item.name == data.name {
//                item.category = data.category
//                item.use = data.use
//                item.amount = Int32(data.amount)
//            }
//        }
//        app.saveContext()
//    }catch{
//        fatalError("Failed to fetch data: \(error)")
//    }
//}
//
////查詢資料
//func selectAccount() -> Array<AccountList> {
//    var array:[AccountDB] = []
//    var ConvertArray: [AccountList] = []
//    let request = NSFetchRequest<DeatilDB>(entityName: "AccountDB")
//    do {
//        let results = try viewContext.fetch(request)
//        for result in results {
//            array.append(result)
//        }
//    }catch{
//        fatalError("Failed to fetch data: \(error)")
//    }
//    
//    for i in array {
//        ConvertArray.append(AccountList(i))
//    }
//    
//    ConvertArray.sort { $0.userCode > $1.userCode}
//    return ConvertArray
//    
//}


//===================================================================================
// MARK: - Group
//===================================================================================

//新增資料
func insertGroupObject(_ obj: GroupList) {
    let Data = NSEntityDescription.insertNewObject(forEntityName: "GroupDB", into: viewContext) as! GroupDB
  
    Data.groupCode = Int32(obj.groupCode)
    Data.whos = toJSON(obj.whos)
    app.saveContext()
}



//刪除所有資料
func deleteGroupAllObject(_ fertilizerData: [GroupList] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<GroupDB>(entityName: "GroupDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
          viewContext.delete(item)
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//刪除資料
func deleteGroupObject(indexPath:IndexPath,_ groupList: [GroupList] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<GroupDB>(entityName: "GroupDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.groupCode == groupList[indexPath.row].groupCode {
                viewContext.delete(item)
            }
        }
        
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//更新資料
func updateGroupObject(_ data:GroupList) {
    //更新:將查詢到的結果更新後，再呼叫context.save()儲存
    let request = NSFetchRequest<GroupDB>(entityName: "GroupDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.groupCode == data.groupCode {
                item.whos = toJSON(data.whos)
            }
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//查詢資料
func selectGroupObject() -> Array<GroupList> {
    var array:[GroupDB] = []
    var ConvertArray: [GroupList] = []
    let request = NSFetchRequest<GroupDB>(entityName: "GroupDB")
    do {
        let results = try viewContext.fetch(request)
        for result in results {
            array.append(result)
        }
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
    
    for i in array {
        ConvertArray.append(GroupList(i))
    }
    
    ConvertArray.sort { $0.groupCode > $1.groupCode}
    return ConvertArray
    
}


//===================================================================================
// MARK: - Schedule
//===================================================================================

//新增資料
func insertScheduleObject(_ obj: Schedule) {
    let Data = NSEntityDescription.insertNewObject(forEntityName: "ScheduleDB", into: viewContext) as! ScheduleDB
    Data.scheduleId = obj.scheduleId
    Data.scheduleCode = Int32(obj.scheduleCode)
    Data.sort =  Int32(obj.sort)
    Data.date = obj.date
    Data.event = obj.event
    Data.note = obj.note
    app.saveContext()
}



//刪除所有資料
func deleteScheduleAllObject(_ fertilizerData: [Schedule] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<ScheduleDB>(entityName: "ScheduleDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
          viewContext.delete(item)
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//刪除資料
func deleteScheduleObject(indexPath:IndexPath,_ schedule: [Schedule] ) {
    //刪除:將查詢到的結果刪除後，再呼叫context.save()儲存
    let request = NSFetchRequest<ScheduleDB>(entityName: "ScheduleDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.scheduleCode == schedule[indexPath.row].scheduleCode {
                viewContext.delete(item)
            }
        }
        
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//更新資料
func updateScheduleObject(_ data:Schedule) {
    //更新:將查詢到的結果更新後，再呼叫context.save()儲存
    let request = NSFetchRequest<ScheduleDB>(entityName: "ScheduleDB")
    do {
        let results = try viewContext.fetch(request)
        for item in results {
            if item.scheduleCode == data.scheduleCode {
                item.sort =  Int32(data.sort)
                item.date = data.date
                item.event = data.event
                item.note = data.note
            }
        }
        app.saveContext()
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
}

//查詢資料
func selectScheduleObject() -> Array<Schedule> {
    var array:[ScheduleDB] = []
    var ConvertArray: [Schedule] = []
    let request = NSFetchRequest<ScheduleDB>(entityName: "ScheduleDB")
    do {
        let results = try viewContext.fetch(request)
        for result in results {
            array.append(result)
        }
    }catch{
        fatalError("Failed to fetch data: \(error)")
    }
    
    for i in array {
        ConvertArray.append(Schedule(i))
    }
    
    ConvertArray.sort { $0.sort < $1.sort}
    return ConvertArray
    
}
