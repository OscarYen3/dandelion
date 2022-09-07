//
//  CharacterList.swift
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

protocol CharacterListDelegate{
    func ReloadMemberList()
}

class CharacterList: UIViewController,UITableViewDelegate,UITableViewDataSource, AddMemberDlgDlgDelegate, DebtDlgDelegate {
    
    var characterList : [String] = []
    var datailInfo: [DeatilProfile] = []
    var groupInfo: GroupList = GroupList()
    var m_oCharacterInfoView: CharacterInfoView?
    var nameList: [String] = []
    var debt: Int = 0
    let db = Firestore.firestore()
    var addMemberItem = UIBarButtonItem()
    var m_DlgAddMember: AddMemberDlg!
    var m_oDebtDlg:  DebtDlg!
    var _delegate : CharacterListDelegate?
    
    @IBOutlet weak var m_table: UITableView!
    @IBOutlet weak var _viewblureffect: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        m_oCharacterInfoView = CharacterInfoView(nibName: Common.xib_CharacterInfoView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_CharacterCell, bundle: nil), forCellReuseIdentifier: Common.xib_CharacterCell)
        m_DlgAddMember = AddMemberDlg(nibName: Common.xib_AddMemberDlg, bundle: nil)
        m_oDebtDlg = DebtDlg(nibName: Common.xib_DebtDlg, bundle: nil)
        addMemberItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add-user"), style: .plain, target: self, action: #selector(addMenber))
        self.navigationItem.rightBarButtonItem = addMemberItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameList = (defaults.array(forKey: "NameList") ?? []) as? [String] ?? []
        m_table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_CharacterCell, for: indexPath) as! CharacterCell
        cell.selectionStyle = .none
        cell.lblName.text = characterList[indexPath.row]
        cell.lblAmount.text = sumAmount(nameList[indexPath.row] )
        cell.processView.progress = (Float(sumAmount(nameList[indexPath.row] )) ?? 0) / Float(debt)
        
        if (Float(sumAmount(nameList[indexPath.row] )) ?? 0) >= 0 {
            cell.processView.progress  = 0 / 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCharacterInfoView {
            oView.amountValue = sumAmount(nameList[indexPath.row] )
            oView.nameValue = characterList[indexPath.row]
            oView.allDetailInfo = datailInfo
            oView.debt = (Float(sumAmount(nameList[indexPath.row] )) ?? 0) / Float(debt)
            oView.navigationItem.title = "詳細資料"
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let controller = UIAlertController(title: "提醒", message: "確定刪除？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "是的", style: .default) { _ in
                if self.checkName(self.characterList[indexPath.row],self.sumAmount(self.nameList[indexPath.row] )) {
                    self.UIShowHaveDebt(true)
                } else {
                    memberArray = defaults.array(forKey: "NameList") ?? []
                    memberArray.remove(at: indexPath.row)
                    defaults.set(memberArray, forKey: "NameList")
                    self.characterList.remove(at: indexPath.row)
                    self.m_table.reloadData()
                    self.groupInfo.whos = memberArray as? [String] ?? []
                    self.groupInfo.date = Date()
                    let target: Int = Int(UserDefaults.GroupCode ?? "") ?? 0
                    self.updateGroupList(target, self.groupInfo)
                }
                
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
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
    
    @objc func addMenber() {
        UIShowAddMember(true)
    }
    
    
    private func DialogShow(_ oView: UIViewController , _ bShow:Bool) {
        
        if(bShow) {
            oView.modalPresentationStyle = .fullScreen
            oView.modalPresentationStyle = .custom
            self.present(oView, animated: true, completion: nil)
            //            self.view.(oView.view)
            oView.view.center = oView.view.center
            setMask(bShow)
            oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            oView.view.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                oView.view.alpha = 1
                oView.view.transform = CGAffineTransform.identity
            }
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                oView.view.alpha = 0
            }) { (success:Bool) in
                oView.dismiss(animated: true)
                self.setMask(bShow)
            }
        }
        
    }
    
    func setMask(_ mask: Bool) {
        _viewblureffect.isHidden = !mask
        self.navigationItem.hidesBackButton = mask
    }
    
    func UIShowAddMember(_ bShow: Bool) {
        if let oView = m_DlgAddMember {
            oView._delegate = self
            DialogShow(oView, bShow)
        }
    }
    
    func UIShowHaveDebt(_ bShow: Bool) {
        if let oView = m_oDebtDlg {
            oView._delegate = self
            DialogShow(oView, bShow)
        }
    }
    
    func OnCancel() {
        UIShowAddMember(false)
       
    }
    
    func OnOK(_ name: String) {
        UIShowAddMember(false)
        _delegate?.ReloadMemberList()
        
    }
    func DebtOnOk() {
        UIShowHaveDebt(false)
    }
    
    func checkName(_ target: String, _ amountValue: String) -> Bool {
        var verify: Bool = false
        for i in datailInfo {
            for name in i.whos {
                if name == target && amountValue == "0" {
                    verify = false
                } else {
                    verify = true
                }
            }
        }
        return verify
    }
    
}
