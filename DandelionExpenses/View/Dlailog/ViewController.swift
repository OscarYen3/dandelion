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
import SwiftyJSON

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,CreateViewDelegate, MFMessageComposeViewControllerDelegate,AccountListDlgDelegate , UIPickerViewDelegate, UIPickerViewDataSource, SlideMenuDelegate, UIViewControllerTransitioningDelegate,CharacterListDelegate {
   
    

    
    @IBOutlet weak var btnTab: UIButton!
    @IBOutlet weak var m_table: UITableView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDebt: UILabel!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnCharacter: UIButton!
    @IBOutlet weak var m_table2: UITableView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var processView: UIProgressView!
    
    let transiton = SlideInTransition()
    var datailInfo: [DeatilProfile] = []
    var groupListInfo: [GroupList] = []
    var m_oCreateView : CreateView!
    let db = Firestore.firestore()
    var m_oAccountDlg : AccountListDlg?
    var m_oCharacterList : CharacterList?
    var debt: Int = 0
    var nameList: [String] = []
    var m_oCharacterInfoView: CharacterInfoView?
    var SelectView = UIPickerView()
    let toolBar = UIToolbar()
    var nameValue: String = ""
    var m_oSideMenu : SideMenuView?
    var m_oVersionUpdateDlg : VersionUpdateDlg?
    var groupInfo: GroupList = GroupList()
    var m_oScheduleView: ScheduleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_oVersionUpdateDlg = VersionUpdateDlg(nibName: Common.xib_VersionUpdateDlg, bundle: nil)
        m_oScheduleView = ScheduleView(nibName: Common.xib_ScheduleView, bundle: nil)
        m_oSideMenu = SideMenuView(nibName: "SideMenuView", bundle: nil)
        rotateToPotrait()
        txtName.placeholder = "請選擇人物"
        processView.transform = processView.transform.scaledBy(x: 1, y: 2)
        processView.trackTintColor = UIColor.systemGroupedBackground
       
        
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                netWork = true
                Log.d("netWorkSucess")
                
            } else {
                netWork = false
                Log.d("netWorkFail")
            }
        }
        AddSideMenuButton()
        monitor.start(queue: DispatchQueue.global())
        m_oCharacterInfoView = CharacterInfoView(nibName: Common.xib_CharacterInfoView, bundle: nil)
        m_oCharacterList = CharacterList(nibName: Common.xib_CharacterList, bundle: nil)
        m_oAccountDlg = AccountListDlg(nibName: Common.xib_AccountListDlg, bundle: nil)
        m_oCreateView = CreateView(nibName: Common.xib_CreateView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_ExpensesCell, bundle: nil), forCellReuseIdentifier: Common.xib_ExpensesCell)
        m_table2.register(UINib(nibName: Common.xib_CharacterCell, bundle: nil), forCellReuseIdentifier: Common.xib_CharacterCell)
        btnTab.addTarget(self, action: #selector(toCreateView), for: .touchUpInside)
        btnAccount.addTarget(self, action: #selector(toAccount), for: .touchUpInside)
        btnCharacter.addTarget(self, action: #selector(toCharacterList), for: .touchUpInside)
        selectViewSet()
        readData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "蒲工英共同帳本"
        nameList = (defaults.array(forKey: "NameList") ?? []) as? [String] ?? []
        m_table.reloadData()
//        m_table2.reloadData()
        
        if txtName.text == "" {
            processView.isHidden = true
            lblInformation.isHidden = true
        }
        
        amountCheck()
    }
    
    func AddSideMenuButton() {
            let btnShowMenu = UIButton(type: UIButton.ButtonType.custom)
            btnShowMenu.setImage(DefaultMenuImage(), for: .normal)
            btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btnShowMenu.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
            let customBarItem = UIBarButtonItem(customView: btnShowMenu)
            self.navigationItem.leftBarButtonItem = customBarItem
        }
    
    func DefaultMenuImage() -> UIImage {
          var defaultMenuImage = UIImage()
          
          UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
          
          UIColor.black.setFill()
          UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
          UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
          UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
          
          UIColor.white.setFill()
          UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
          UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
          UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
          
          defaultMenuImage = #imageLiteral(resourceName: "menu") //UIGraphicsGetImageFromCurrentImageContext()!
          
          UIGraphicsEndImageContext()
          
          return defaultMenuImage;
      }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton) {
        Log.d("onSlideMenuButtonPressed")
        sender.tag = 10
        
        if let sidemenu = m_oSideMenu {
            sidemenu._btnMenu = sender
            sidemenu._delegate = self
            sidemenu.transitioningDelegate = self
            sidemenu.modalPresentationStyle = .overCurrentContext
            present(sidemenu, animated: true, completion: nil)
        }
    }
    
    func SideMenuItemSelectedAtIndex(_ index: Int) {
        let sidemenu : [String] = ["聯絡我","Google相簿連結","行程規劃"]
        if index > -1 {
            switch(sidemenu[index]){
            case "聯絡我":
                UIApplication.shared.openURL(NSURL(string: "mailto:haha780205@gmail.com")! as URL)
                break
            case "Google相簿連結":
                let urlString = "https://photos.google.com/albums?pli=1"
                let url = NSURL(string: urlString)
                UIApplication.shared.openURL(url! as URL)
                break
            case "行程規劃":
                if let oView = m_oScheduleView {
                    oView.navigationItem.title = "行程規劃"
                    self.navigationItem.backButtonTitle = ""
                    self.navigationController?.pushViewController(oView, animated: true)
                }
                break
            default:
                
                break
            }
        }
        
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
//            var negativenumber: Int = 0
//            cell.selectionStyle = .none
//            if indexPath.row > nameList.count {
//
//            } else {
//                cell.lblName.text = (nameList[indexPath.row] )
//                cell.lblAmount.text = String(sumAmount2(nameList[indexPath.row] ))
//                negativenumber = sumAmount2(nameList[indexPath.row] )
//                if negativenumber < 0 {
//                    debt += negativenumber
//                }
//            }
//
//            lblDebt.text =  String(format: "%d" , debt)
            
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
            oView.debt = self.debt
            nameList = (defaults.array(forKey: "NameList") ?? []) as? [String] ?? []
            oView.characterList = nameList
            oView.datailInfo = datailInfo
            oView.navigationItem.title = "人員列表"
            oView._delegate = self
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
        lblAmount.text = String(amount)
        debt = 0
        debtCheck()
//        m_table2.reloadData()
    }
    
    func readData() {
        if UserDefaults.Account == "" {
            UserDefaults.Account = Common.collection2
        }
        db.collection(UserDefaults.Account ?? Common.collection2).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                deleteAllObject(selectObject())
                for document in querySnapshot.documents {
                    print(document.data())
                    self.dataConvert(target: document)
                }
                self.datailInfo = selectObject()
                self.db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).getDocuments { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        deleteGroupAllObject(selectGroupObject())
                        for document in querySnapshot.documents {
                            print(document.data())
                            
                            self.groupConvert(target: document,  who: self.getAllName(self.datailInfo))
                        }
                    }
                }
                
                self.db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Schedule") ).getDocuments { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        deleteGroupAllObject(selectGroupObject())
                        for document in querySnapshot.documents {
                            print(document.data())
                            
                            self.scheduleConvert(target: document)
                        }
                    }
                }
                
                
                
                
            }
            
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
        
    func groupConvert(target: QueryDocumentSnapshot,who:[String]){
            let data: GroupList = GroupList()
            for i in target.data() {
                switch i.key {
                case "groupCode":
                    data.groupCode = i.value as! Int
                case "whos":
                    data.whos = i.value as! [String]
                default:
                    break
                }
                
            }
        data.groupId = target.documentID
        insertGroupObject(GroupList(data))
        memberArray = data.whos
        for i in who {
            memberArray.append(i)
        }
        let memberList: [String] = memberArray as? [String] ?? []
        defaults.set(memberList.removeDuplicateElement(), forKey: "NameList")
        self.nameList = (defaults.array(forKey: "NameList") ?? []) as? [String] ?? []
        UserDefaults.GroupCode =  String(data.groupCode)
        updateNameList()
    }
    
    func scheduleConvert(target: QueryDocumentSnapshot){
        let data: Schedule = Schedule()
        for i in target.data() {
            switch i.key {
            case "date":
                data.date = i.value as! Date
            case "event":
                data.event = i.value as! String
            case "note":
                data.note = i.value as! String
            default:
                break
            }
            
        }
        data.scheduleId = target.documentID
        insertScheduleObject(Schedule(data))
        
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
//        var ref: DocumentReference? = nil
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
    
    func sumAmount(_ target: String) -> String {
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
        return String(amount)
    }

    @IBAction func toInfo(_ sender: Any) {
        if txtName.text == "" {
            doneClick()
        } else {
            self.navigationItem.backButtonTitle = ""
            toInfo(txtName.text ?? "")
        }
        
    }
    
    func toInfo(_ name: String) {
        if let oView = m_oCharacterInfoView {
            oView.amountValue = sumAmount(name)
            oView.nameValue = name
            oView.allDetailInfo = datailInfo
            oView.debt = (Float(sumAmount(name)) ?? 0) / Float(debt)
            oView.navigationItem.title = "詳細資料"
            self.navigationController?.pushViewController(oView, animated: true)
        }
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
        txtName.inputView = SelectView
        txtName.inputAccessoryView = toolBar

    }
    
    @objc func doneClick()  {
        if nameValue == "" {
            txtName.text = nameList[0]
        } else {
            txtName.text = nameValue
        }
        
        processView.progress = (Float(sumAmount(txtName.text ?? "")) ?? 0) / Float(debt)
        if (Float(sumAmount(txtName.text ?? "")) ?? 0) >= 0 {
            processView.progress = 0 / 1
        }
        lblInformation.text = sumAmount(txtName.text ?? "")
        processView.isHidden = false
        lblInformation.isHidden = false
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    
    //================================================================================================
    // MARK: - SelectBeanType
    //================================================================================================
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return nameList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return nameList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameValue = nameList[row]
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

        pickerLabel?.text = nameList[row]
        return pickerLabel!
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           transiton.isPresenting = true
           return transiton
       }

       func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           transiton.isPresenting = false
           return transiton
       }
    
    func ReloadMemberList() {
        if UserDefaults.Account == "" {
            UserDefaults.Account = Common.collection2
        }
        db.collection(UserDefaults.Account ?? Common.collection2).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                deleteAllObject(selectObject())
                for document in querySnapshot.documents {
                    print(document.data())
                    self.dataConvert(target: document)
                }
                
                self.datailInfo = selectObject()
                self.db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).getDocuments { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        deleteGroupAllObject(selectGroupObject())
                        for document in querySnapshot.documents {
                            print(document.data())
                            self.groupConvert(target: document, who: self.getAllName(self.datailInfo))
                        }
                        if let oView = self.m_oCharacterList {
                            oView.characterList = self.nameList
                            oView.nameList  = self.nameList
                            oView.m_table.reloadData()
                        }
                    }
                }
                
                self.db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Schedule") ).getDocuments { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        deleteGroupAllObject(selectGroupObject())
                        for document in querySnapshot.documents {
                            print(document.data())
                            
                            self.scheduleConvert(target: document)
                        }
                    }
                }
                
            }
            
            self.amountCheck()
        }
        
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路不能更新最新資料" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func appleCheck() {
           let id: String = Bundle.main.bundleIdentifier ?? ""
           let link = "https://itunes.apple.com/lookup?bundleId=\(id)"
           let url: URL = URL(string: link)!
           let session = URLSession.shared
           let request = NSMutableURLRequest(url: url)
           request.httpMethod = "GET"
           request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
           let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
               guard let data: Data = data, let _: URLResponse = response, error == nil else {
                   Log.d("ERROR at AppDelegate(checkAppVersion): Fetch App Info fail)")
                   return
               }
               self.extractJSON(from: data)
           })
           task.resume()
       }


           func extractJSON(from data: Data) {
           do {
               let json = try JSON(data: data)
               let appStoreVersion = json["results"][0]["version"].stringValue
               let updateState: Int = VersionCompare(Bundle.main.versionNumber,(appStoreVersion))
               if updateState == 1 {
                   
                   self.UIShowVersionUpdateDlg()
               }
           } catch {
               Log.d("ERROR at AppDelegate(extractJSON): \(error)")
               return
           }
       }

    func UIShowVersionUpdateDlg() {
        if let oView = m_oVersionUpdateDlg {
            DispatchQueue.main.async {
                oView.modalPresentationStyle = .fullScreen
                oView.modalPresentationStyle = .custom
                oView.view.backgroundColor = UIColor.init(red: 4/255.0, green: 4/255.0, blue: 15/255.0, alpha: 0.75)
                self.present(oView, animated: true, completion: nil)
            }
        }
    }
    
    func getAllName(_ data: [DeatilProfile]) -> [String] {
        var allname:[String] = []
        for i in data {
            for who in i.whos {
                allname.append(who)
            }
        }
        return allname.removeDuplicateElement()
    }
    

    func updateNameList() {
        self.groupInfo.whos = memberArray as? [String] ?? []
        self.groupInfo.date = Date()
        let target: Int = Int(UserDefaults.GroupCode ?? "") ?? 0
        self.updateGroupList(target, self.groupInfo)
    }
    
    func updateGroupList(_ target: Int, _ data: GroupList) {
            db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Group") ).whereField("groupCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["date":data.date ])
                    document?.reference.updateData(["whos": data.whos.removeDuplicateElement()], completion: { (error) in
                    })
                }
            }
        }
    
    func debtCheck() {
        var negativenumber = 0
        for i in nameList {
            negativenumber = sumAmount2(i)
            if negativenumber < 0 {
                debt += negativenumber
            }
        }
        
        lblDebt.text =  String(format: "%d" , debt)
    }
    
    
    
    
    
}

extension Array where Element: Hashable {
    
    func removeDuplicateElement() -> [Element] {
        var elementSet = Set<String>()

        return filter {
            elementSet.update(with: $0 as! String) == nil
        }
    }
    
    
}
