//
//  Common.swift
//  shindeji
//
//  Created by Oscar on 2021/7/3.
//

import Foundation
import CoreData
import Network
import UIKit

class Common {
    
    static let xib_CreateView       = "CreateView"
    static let xib_ExpensesCell     =  "ExpensesCell"
    static let xib_CharacterCell    =  "CharacterCell"
    static let xib_NameCell         =  "NameCell"
    static let xib_AddMemberDlg     =  "AddMemberDlg"
    static let xib_AccountListDlg   =  "AccountListDlg"
    static let xib_CharacterList   =  "CharacterList"
    static let xib_CharacterInfoView   =  "CharacterInfoView"

    static let collection           = "Dandelion"
    static let collection2          = "Public"
}

let app = UIApplication.shared.delegate as! AppDelegate
let viewContext = app.persistentContainer.viewContext
let monitor = NWPathMonitor()
var netWork: Bool = false
let defaults = UserDefaults.standard

enum UserType {
case create
case edit
case infomation
}

//var NameList:[String] =
//["熊","潘",
// "婕","毛","楊",
// "佳","Cola",
// "轟","禿",
// "帥","良",
// "宣","凃",
// "文","Mo",
// "圓","Nick",
// "雯","Billy",]

func rotateToPotrait() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.myOrientation = .all
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    appDelegate.myOrientation = .portrait
    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    UIView.setAnimationsEnabled(true)
    
}

extension UserDefaults {
    private enum Key : String {
        case Account = "Account"
        case Accounts = "Accounts"
        case GroupCode = "GroupCode"
    }
    
    static var Account: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.Account.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            if let value = value {
                defs.set(value, forKey: Key.Account.rawValue)
                return
            }
            defs.removeObject(forKey: Key.Account.rawValue)
        }
    }
    
    static var Accounts: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.Accounts.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            if let value = value {
                defs.set(value, forKey: Key.Accounts.rawValue)
                return
            }
            defs.removeObject(forKey: Key.Accounts.rawValue)
        }
    }
    
    static var GroupCode: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.GroupCode.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            if let value = value {
                defs.set(value, forKey: Key.GroupCode.rawValue)
                return
            }
            defs.removeObject(forKey: Key.GroupCode.rawValue)
        }
    }
    
    
}
