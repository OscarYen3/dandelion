//
//  CharacterList.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/17.
//

import UIKit

class CharacterList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var characterList : [String] = []
    var datailInfo: [DeatilProfile] = []
    var m_oCharacterInfoView: CharacterInfoView?
    var nameList: [Any] = []
    
    @IBOutlet weak var m_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        m_oCharacterInfoView = CharacterInfoView(nibName: Common.xib_CharacterInfoView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_CharacterCell, bundle: nil), forCellReuseIdentifier: Common.xib_CharacterCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameList = defaults.array(forKey: "NameList") ?? []
        m_table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_CharacterCell, for: indexPath) as! CharacterCell
        cell.selectionStyle = .none
        cell.lblName.text = characterList[indexPath.row]
        cell.lblAmount.text = sumAmount(nameList[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCharacterInfoView {
            oView.amountValue = sumAmount(nameList[indexPath.row] as! String)
            oView.nameValue = characterList[indexPath.row]
            oView.allDetailInfo = datailInfo
            oView.navigationItem.title = "詳細資料"
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           let controller = UIAlertController(title: "提醒", message: "確定刪除？", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "是的", style: .default) { _ in
               memberArray = defaults.array(forKey: "NameList") ?? []
               memberArray.remove(at: indexPath.row)
               defaults.set(memberArray, forKey: "NameList")
               self.characterList.remove(at: indexPath.row)
               self.m_table.reloadData()
              
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

}
