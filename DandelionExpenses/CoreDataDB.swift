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


