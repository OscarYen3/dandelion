//
//  AddMemberDlg.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/15.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
import MessageUI
import Messages
import FirebaseMessaging

protocol AddMemberDlgDlgDelegate{
    func OnCancel()
    func OnOK(_ name:String)
}

var memberArray:[Any] = []

class AddMemberDlg: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    
    var _delegate : AddMemberDlgDlgDelegate?
    let db = Firestore.firestore()
    var groupInfo: GroupList = GroupList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func cancelClcik(_ sender: Any) {
        _delegate?.OnCancel()
    }
    
    @IBAction func okClick(_ sender: Any) {
        if txtName.text != "" {
            memberArray = defaults.array(forKey: "NameList") ?? []
            memberArray.append(txtName.text ?? "")
            defaults.set(memberArray, forKey: "NameList")
            self.groupInfo.whos = memberArray as? [String] ?? []
            self.groupInfo.date = Date()
            let target: Int = Int(UserDefaults.GroupCode ?? "") ?? 0
            self.updateGroupList(target, self.groupInfo)
        }
        _delegate?.OnOK(txtName.text ?? "")
    }
    
    func updateGroupList(_ target: Int, _ data: GroupList) {
        db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).whereField("groupCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
               if let querySnapshot = querySnapshot {
                   let document = querySnapshot.documents.first
                   document?.reference.updateData(["date":data.date ])
                   document?.reference.updateData(["whos": data.whos ], completion: { (error) in
                   })
               }
           }
       }
}
