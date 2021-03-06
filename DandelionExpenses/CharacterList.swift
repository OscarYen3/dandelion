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
    var nameList: [String] = []
    var debt: Int = 0
    
    @IBOutlet weak var m_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        m_oCharacterInfoView = CharacterInfoView(nibName: Common.xib_CharacterInfoView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_CharacterCell, bundle: nil), forCellReuseIdentifier: Common.xib_CharacterCell)
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCharacterInfoView {
            oView.amountValue = sumAmount(nameList[indexPath.row] )
            oView.nameValue = characterList[indexPath.row]
            oView.allDetailInfo = datailInfo
            oView.debt = (Float(sumAmount(nameList[indexPath.row] )) ?? 0) / Float(debt)
            oView.navigationItem.title = "????????????"
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {
           let controller = UIAlertController(title: "??????", message: "???????????????", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "??????", style: .default) { _ in
               memberArray = defaults.array(forKey: "NameList") ?? []
               memberArray.remove(at: indexPath.row)
               defaults.set(memberArray, forKey: "NameList")
               self.characterList.remove(at: indexPath.row)
               self.m_table.reloadData()
              
           }
           controller.addAction(okAction)
           let cancelAction = UIAlertAction(title: "??????", style: .cancel, handler: nil)
           controller.addAction(cancelAction)
           present(controller, animated: true, completion: nil)
       }
   }
    
    func sumAmount(_ target: String) -> String {
        var amount: Int = 0
        for i in datailInfo {
            for name in i.whos {
                if name == target {
                    if i.use == "??????" {
                        amount += i.amount
                    } else if i.use == "??????" {
                        amount -= i.amount
                    } else if i.use == "??????" {
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
