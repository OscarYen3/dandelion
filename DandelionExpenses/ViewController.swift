//
//  ViewController.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/13.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
import MessageUI
import Messages
import FirebaseMessaging

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,CreateViewDelegate, MFMessageComposeViewControllerDelegate,AccountListDlgDelegate {

    @IBOutlet weak var btnTab: UIButton!
    @IBOutlet weak var m_table: UITableView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDebt: UILabel!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnCharacter: UIButton!
    @IBOutlet weak var m_table2: UITableView!
    
    var datailInfo: [DeatilProfile] = []
    var m_oCreateView : CreateView!
    let db = Firestore.firestore()
    var m_oAccountDlg : AccountListDlg?
    var m_oCharacterList : CharacterList?
    var debt: Int = 0
    var nameList: [Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                netWork = true
                print("netWorkSucess")
                
            } else {
                netWork = false
                print("netWorkFail")
            }
        }
        monitor.start(queue: DispatchQueue.global())
        m_oCharacterList = CharacterList(nibName: Common.xib_CharacterList, bundle: nil)
        m_oAccountDlg = AccountListDlg(nibName: Common.xib_AccountListDlg, bundle: nil)
        m_oCreateView = CreateView(nibName: Common.xib_CreateView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_ExpensesCell, bundle: nil), forCellReuseIdentifier: Common.xib_ExpensesCell)
        m_table2.register(UINib(nibName: Common.xib_CharacterCell, bundle: nil), forCellReuseIdentifier: Common.xib_CharacterCell)
        btnTab.addTarget(self, action: #selector(toCreateView), for: .touchUpInside)
        btnAccount.addTarget(self, action: #selector(toAccount), for: .touchUpInside)
        btnCharacter.addTarget(self, action: #selector(toCharacterList), for: .touchUpInside)
//        let array = ["Hello", "Swift"]
//        defaults.set(array, forKey: "NameList")
       
        readData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "蒲工英共同帳本"
        nameList = defaults.array(forKey: "NameList") ?? []
        m_table.reloadData()
        m_table2.reloadData()
        amountCheck()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case m_table:
            return datailInfo.count
        case m_table2:
            return nameList.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case m_table:
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_ExpensesCell, for: indexPath) as! ExpensesCell
            cell.selectionStyle = .none
            cell.lblName.text = datailInfo[indexPath.row].name
            cell.lblCategory.text = datailInfo[indexPath.row].category
            cell.lblUse.text = datailInfo[indexPath.row].use
            cell.lblAmount.text =  "\(datailInfo[indexPath.row].amount)"
            
            if cell.lblUse.text == "支出" {
                cell.lblUse.textColor = UIColor.red
            } else if cell.lblUse.text == "公費" {
                cell.lblUse.textColor = UIColor.green
            } else if cell.lblUse.text == "領錢" {
                cell.lblUse.textColor = UIColor.blue
            } else {
                cell.lblUse.textColor = UIColor.red
            }
            
            return cell
        case m_table2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_CharacterCell, for: indexPath) as! CharacterCell
            var negativenumber: Int = 0
            cell.selectionStyle = .none
            cell.lblName.text = nameList[indexPath.row] as! String
            cell.lblAmount.text = String(sumAmount2(nameList[indexPath.row] as! String))
            negativenumber = sumAmount2(nameList[indexPath.row] as! String)
            if negativenumber < 0 {
                debt += negativenumber
            }
            lblDebt.text =  String(format: "%@ : %d" , "負債分擔" , debt)
            return cell
        default:
            break
        }
        return  UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let controller = UIAlertController(title: "提醒", message: "確定刪除？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "是的", style: .default) { _ in
                self.deleteDocument(self.datailInfo[indexPath.row].userid)
                deleteObject(indexPath: indexPath, self.datailInfo)
                self.datailInfo.remove(at: indexPath.row)
                self.m_table.reloadData()
                self.amountCheck()
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCreateView {
            oView._delegate = self
            oView.whos = datailInfo[indexPath.row].whos
            oView.nameValue = datailInfo[indexPath.row].name
            oView.categoryValue = datailInfo[indexPath.row].category
            oView.amountValue = String(datailInfo[indexPath.row].amount)
            oView.useValue = datailInfo[indexPath.row].use
            oView.userType = .edit
            oView.userCodeValue  = datailInfo[indexPath.row].userCode
            oView.navigationItem.title = "編輯"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func SaveDetail(detailProfile: DeatilProfile) {
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路則無法新增" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            datailInfo.insert(detailProfile, at: 0)
            addData(detailProfile)
            readData()
        }
    }
    
    func EditDetail(detailProfile: DeatilProfile) {
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路則無法新增" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            for (index,value) in datailInfo.enumerated() {
                if value.name == detailProfile.name {
                    datailInfo[index] = detailProfile
                }
            }
            updateData(detailProfile.userCode, detailProfile)
            m_table.reloadData()
        }
    }
    
    @objc  func toCreateView() {
        if let oView = m_oCreateView {
            oView._delegate = self
            oView.userType = .create
            oView.whos = []
            oView.nameValue = ""
            oView.categoryValue = ""
            oView.amountValue = ""
            oView.userCodeValue  = 0
            oView.navigationItem.title = "收支紀錄"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    @objc func toCharacterList() {
        if let oView = m_oCharacterList {
            nameList = defaults.array(forKey: "NameList") ?? []
            oView.characterList = nameList as? [String] ?? []
            oView.datailInfo = datailInfo
            oView.navigationItem.title = "人員列表"
            self.navigationItem.backButtonTitle = ""
            
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func amountCheck() {
        var amount: Int = 0
        for i in datailInfo {
            if i.use == "公費" {
                amount += i.amount
            } else if i.use == "領錢" {
                amount -= i.amount
            } else if i.name == "公費" {
                amount -= i.amount
            }
        }
        lblAmount.text =  "公費:" + String(amount)
        debt = 0
        m_table2.reloadData()
    }
    
    func readData() {
        db.collection(UserDefaults.Account ?? Common.collection2).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                deleteAllObject(selectObject())
                for document in querySnapshot.documents {
                    print(document.data())
                    self.dataConvert(target: document)
                }
            }
            self.datailInfo = selectObject()
            self.m_table.reloadData()
            self.amountCheck()
        }
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路不能更新最新資料" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    func dataConvert(target: QueryDocumentSnapshot){
        let data: DeatilProfile = DeatilProfile()
        for i in target.data() {
            switch i.key {
            case "name":
                data.name = i.value as! String
            case "category":
                data.category = i.value as! String
            case "use":
                data.use = i.value as! String
            case "amount":
                data.amount = i.value as! Int
            case "userCode":
                data.userCode = i.value as! Int
            case "whos":
                data.whos = i.value as! [String]
            default:
                break
            }
            
        }
        data.userid = target.documentID
        insertObject(DeatilProfile(data))
        
    }
    
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
        var ref: DocumentReference? = nil
        ref = db.collection(UserDefaults.Account ?? Common.collection2).addDocument(data: [
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
    
    @IBAction func refresh(_ sender: Any) {
        readData()
    }
    func ChangeAccount() {
        readData()}
    
    @IBAction func sendSmsClick(_ sender: AnyObject) {
            guard MFMessageComposeViewController.canSendText() else {
                return
            }

            let messageVC = MFMessageComposeViewController()

            messageVC.body = "Enter a message";
            messageVC.recipients = ["+0953212293"]
            messageVC.messageComposeDelegate = self

            self.present(messageVC, animated: false, completion: nil)
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result.rawValue) {
                case MessageComposeResult.cancelled.rawValue:
                print("Message was cancelled")
                self.dismiss(animated: true, completion: nil)
            case MessageComposeResult.failed.rawValue:
                print("Message failed")
                self.dismiss(animated: true, completion: nil)
            case MessageComposeResult.sent.rawValue:
                print("Message was sent")
                self.dismiss(animated: true, completion: nil)
            default:
                break;
            }
        }
    @objc func toAccount(){
        if let oView = m_oAccountDlg {
            oView._delegate = self
            oView.modalPresentationStyle = .custom
            oView.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.present(oView, animated: false, completion: nil)
        }
    }
    func sumAmount2(_ target: String) -> Int {
        var amount: Int = 0
        for i in datailInfo {
            for name in i.whos {
                if name == target {
                    if i.use == "公費" {
                        amount += i.amount
                    } else if i.use == "領錢" {
                        amount -= i.amount
                    } else if i.use == "支出" {
                        if i.name == name   {
                            amount  += i.amount
                        }
                        amount -= i.amount / (i.whos.count)
                    }
                }
            }
        }
        return amount
    }
}

