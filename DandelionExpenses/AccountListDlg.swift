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
    var groupListInfo: GroupList = GroupList()
    var groupList: [GroupList] = []
    

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var InputAccount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountList = [ Common.collection2 , Common.collection]
        btnAdd.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        btnConfirm.addTarget(self, action: #selector(confirm), for: .touchUpInside)
//        btnAdd.isHidden = true
        btnCancel.addTarget(self, action: #selector(exit), for: .touchUpInside)
        selectViewSet()
    }
    
    func selectViewSet() {
        txtAccount.text = ""
        InputAccount.text = ""
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
        self.InputAccount.text = ""
      
        self.view.endEditing(true)
        toolBar.endEditing(true)
        UserDefaults.Account = accountValue
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    
   
    @IBAction func inputClick(_ sender: Any) {
        self.txtAccount.text = ""
    }
    
    @objc func addClick() {
        self.InputAccount.text = ""
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
                self.InputAccount.text = (controller.textFields?[0].text ?? "") + "\(Int(timeInterval))"
                self.groupListInfo.date = Date()
                self.groupListInfo.whos = ["PasserbyNo.1"]
                self.groupListInfo.groupCode = Int((Int32(timeInterval)))
                defaults.set(self.groupListInfo.whos, forKey: "NameList")
                self.addGroupList(self.groupListInfo, self.InputAccount.text ?? "")
            } else {
                
            }
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func exit() {
       
        dismiss(animated: true)
    }
    
    
    @objc func confirm() {
        
        
        //        _ = UserDefaults.Account ?? ""
        //        _ = Date().timeIntervalSince1970
        if self.InputAccount.text != "" {
            UserDefaults.Account =  self.InputAccount.text
//            UserDefaults.Account = String(format: "%@%@",self.InputAccount.text ?? "","\(Int(timeInterval))") 
            Messaging.messaging().subscribe(toTopic: UserDefaults.Account ?? "")
            _delegate?.ChangeAccount()
            dismiss(animated: true)
        } else if self.txtAccount.text != ""{
            UserDefaults.Account = self.txtAccount.text
            Messaging.messaging().subscribe(toTopic: UserDefaults.Account ?? "")
            _delegate?.ChangeAccount()
            dismiss(animated: true)
        } else {
            self.view.showToast(toastMessage: "選項不能為空", duration: 2)
        }
        
       
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
    
    
    func addGroupList(_ group: GroupList,_ groupName: String) {
        UserDefaults.Account = groupName
        _ = db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).addDocument(data: [
            "date": group.date ,
            "groupCode": group.groupCode,
            "whos": group.whos
          ]) { (error) in
              if let error = error {
                  print(error)
              }
          }
      }
    
    func updateGroupList(_ target: Int, _ data: GroupList) {
        db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).whereField("groupCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
               if let querySnapshot = querySnapshot {
                   let document = querySnapshot.documents.first
                   document?.reference.updateData(["date":data.date ])
                   document?.reference.updateData(["whos": data.whos.removeDuplicateElement() ], completion: { (error) in
                   })
               }
           }
       }
    
    
    @IBAction func shareClick(_ sender: Any) {
        if InputAccount.text == "" {
            self.view.showToast(toastMessage: "帳本不能為空", duration: 2)
        } else {
            self.shareAccount()
        }
        
    }
    
    
    func shareAccount() {
      
        let newdisplay = String(format: "%@%@", "This is my Account Name: ",InputAccount.text ?? "")
        let activityVC = UIActivityViewController(activityItems: [newdisplay], applicationActivities: nil)

        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if error != nil {
                self.view.showToast(toastMessage: "OMG!!!失敗了啦！！", duration: 2)
                return
            }
            if completed {
                self.view.showToast(toastMessage: "成功分享", duration: 2)
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            var popoverController : UIPopoverPresentationController!
            popoverController = activityVC.popoverPresentationController
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection()
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
}



