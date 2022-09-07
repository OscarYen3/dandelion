//
//  AccountModel.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/3/4.
//

import Foundation
class AccountInfo: Codable {
    var account : String
    var password : String
    var whos : [String]
   
    init() {
        self.account = ""
        self.password = ""
        self.whos = []
    }
}

class AccountList: Codable {
    var accounts : [String]
   
    init() {
        self.accounts = []
    }
}
