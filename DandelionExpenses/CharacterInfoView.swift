//
//  CharacterInfoView.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/17.
//

import UIKit

class CharacterInfoView: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    
    @IBOutlet weak var m_table: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    var m_oCreateView : CreateView!
    
    var characterInfo : [DeatilProfile] = []
    var allDetailInfo : [DeatilProfile] = []
    var nameValue: String = ""
    var amountValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        m_oCreateView = CreateView(nibName: Common.xib_CreateView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_ExpensesCell, bundle: nil), forCellReuseIdentifier: Common.xib_ExpensesCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblName.text = nameValue
        lblAmount.text = amountValue
        conversionData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_ExpensesCell, for: indexPath) as! ExpensesCell
        cell.selectionStyle = .none
        cell.lblName.text = characterInfo[indexPath.row].name
        cell.lblCategory.text = characterInfo[indexPath.row].category
        cell.lblUse.text = characterInfo[indexPath.row].use
        cell.lblAmount.text = "\(characterInfo[indexPath.row].amount)"
        
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCreateView {
          
            oView.whos = characterInfo[indexPath.row].whos
            oView.nameValue = characterInfo[indexPath.row].name
            oView.categoryValue = characterInfo[indexPath.row].category
            oView.amountValue = String(characterInfo[indexPath.row].amount)
            oView.useValue = characterInfo[indexPath.row].use
            oView.userType = .infomation
            oView.userCodeValue  = characterInfo[indexPath.row].userCode
            oView.navigationItem.title = "詳細資料查詢"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func conversionData() {
        characterInfo = []
        for i in allDetailInfo {
            for name in i.whos {
                if name == nameValue {
                    characterInfo.append(i)
                }
            }
        }
        m_table.reloadData()
    }
    

}
