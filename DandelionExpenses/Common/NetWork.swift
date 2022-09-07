//
//  NetWork.swift
//  shindeji
//
//  Created by Oscar on 2021/7/11.
//

import Foundation

struct UrlRequestTask{
    static let shared = UrlRequestTask()
    var sheetDBOrderLink = "https://sheetdb.io/api/v1/moedt6d7ypf35"
    var spreadSheetLink = "https://docs.google.com/spreadsheets/d/1E4es8WUkr9-DUcg9eTgGO0rhkeYehKy3YmFLthfT8zQ/edit#gid=0"
    var sheetDBLink = "https://script.google.com/macros/s/AKfycbyB5cxJ9prcOqjrveVoZ3JhxPWHwyEJr-RbAGPTqtrQ8OFl0kM/exec"
    var baseRequest = URLRequest(url: URL(string: "https://sheetdb.io/api/v1/lrpmxtfvwwgn7")!)
}



