//
//  AccountListDlg.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/17.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
import MessageUI
import Messages
import FirebaseMessaging

protocol AccountListDlgDelegate {
    func ChangeAccount()
}

class AccountListDlg: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var accountList:[String] = []
    var SelectView = UIPickerView()
    let toolBar = UIToolbar()
    var accountValue: String = ""
    var _delegate:AccountListDlgDelegate?
    let db = Firestore.firestore()
    

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        accountList = [ Common.collection2 , Common.collection]
        btnAdd.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        btnConfirm.addTarget(self, action: #selector(exit), for: .touchUpInside)
//        btnAdd.isHidden = true
        btnCancel.addTarget(self, action: #selector(exit), for: .touchUpInside)
        selectViewSet()
    }
    
    func selectViewSet() {
        SelectView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        SelectView.delegate = self
        SelectView.dataSource = self
        SelectView.backgroundColor = UIColor.white
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtAccount.inputView = SelectView
        txtAccount.inputAccessoryView = toolBar
    
    }
    
    //================================================================================================
    // MARK: - SelectBeanType
    //================================================================================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return accountList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return accountList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountValue = accountList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 22)
        }
        pickerLabel?.numberOfLines = 0
        pickerLabel?.minimumScaleFactor = 0.6
        pickerLabel?.textAlignment = .center
        
        pickerLabel?.text = accountList[row]
        return pickerLabel!
    }
    
    @objc func doneClick()  {
        if accountValue == "" {
            txtAccount.text = accountList[0]
        } else {
            txtAccount.text = accountValue
        }
        
      
        self.view.endEditing(true)
        toolBar.endEditing(true)
        UserDefaults.Account = accountValue
        
        
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    
    @objc func addClick() {
//        let controller = UIAlertController(title: "提示", message: "尚未提供此功能", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        controller.addAction(okAction)
//        present(controller, animated: true, completion: nil)
        
        let controller = UIAlertController(title: "提示", message: "請輸入新帳本名稱", preferredStyle: .alert)
        controller.addTextField { textField in
           textField.placeholder = "帳本名稱"
           
        }
      
        let timeInterval = Date().timeIntervalSince1970
        let okAction = UIAlertAction(title: "確定", style: .default) { [unowned controller] _ in
            if controller.textFields?[0].text != "" {
                UserDefaults.Account = (controller.textFields?[0].text ?? "") + "\(timeInterval)"
                self.txtAccount.text = UserDefaults.Account ?? "" + "\(timeInterval)"
            } else {
                
            }
            
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func exit() {
        if  txtAccount.text == accountList[0] {
            let array = ["option1","option2"]
            defaults.set(array, forKey: "NameList")
        } else  if txtAccount.text == accountList[1]  {
            let array = NameList
            defaults.set(array, forKey: "NameList")
        } else {
            let array = ["option1"]
            defaults.set(array, forKey: "NameList")
        }
        
        let topic = UserDefaults.Account ?? ""
        for i in self.accountList {
            Messaging.messaging().unsubscribe(fromTopic: i)
        }
        Messaging.messaging().subscribe(toTopic: topic)
        _delegate?.ChangeAccount()
        dismiss(animated: true)
    }
    
    //07/04 還用不到
//    func dataConvert(target: QueryDocumentSnapshot){
//        let data: AccountList = AccountList()
//        for i in target.data() {
//            switch i.key {
//            case "accounts":
//                data.accounts = i.value as! [String]
//            default:
//                break
//            }
//
//        }
//
//        insertObject(DeatilProfile(data))
//
//    }
    
    func deleteDocument(_ target: String?) {
        guard let newTarget = target else { return }
        db.collection(UserDefaults.Account ?? Common.collection2).document(newTarget).delete() { err   in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    
    func addData(_ profile: DeatilProfile) {
        _ = db.collection(UserDefaults.Account ?? Common.collection2).addDocument(data: [
            "name": profile.name,
            "category": profile.category,
            "use": profile.use,
            "amount": profile.amount,
            "date": profile.date,
            "userCode": profile.userCode,
            "whos": profile.whos,
          ]) { (error) in
              if let error = error {
                  print(error)
              }
          }
      }
    
    func updateData(_ target: Int, _ data: DeatilProfile) {
        db.collection(UserDefaults.Account ?? Common.collection2).whereField("userCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
               if let querySnapshot = querySnapshot {
                   let document = querySnapshot.documents.first
                document?.reference.updateData(["name":data.name])
                document?.reference.updateData(["category":data.category])
                document?.reference.updateData(["use":data.use])
                document?.reference.updateData(["amount":data.amount])
                document?.reference.updateData(["date":data.date])
                document?.reference.updateData(["whos": data.whos], completion: { (error) in
                   })
               }
           }
       }
    
    
    func addGroupList(_ profile: DeatilProfile) {
        _ = db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"成員名單") ).addDocument(data: [
            "name": profile.name,
            "category": profile.category,
            "use": profile.use,
            "amount": profile.amount,
            "date": profile.date,
            "userCode": profile.userCode,
            "whos": profile.whos,
          ]) { (error) in
              if let error = error {
                  print(error)
              }
          }
      }
    
    func updateGroupList(_ target: Int, _ data: DeatilProfile) {
        db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"成員名單") ).whereField("userCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
               if let querySnapshot = querySnapshot {
                   let document = querySnapshot.documents.first
                document?.reference.updateData(["name":data.name])
                document?.reference.updateData(["category":data.category])
                document?.reference.updateData(["use":data.use])
                document?.reference.updateData(["amount":data.amount])
                document?.reference.updateData(["date":data.date])
                document?.reference.updateData(["whos": data.whos], completion: { (error) in
                   })
               }
           }
       }
    
    
}



