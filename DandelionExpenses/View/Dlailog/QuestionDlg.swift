//
//  QuestionDlg.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2024/8/27.
//

import UIKit

class QuestionDlg: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblInfo.text =
        """
         1.本帳本計算方式為所有人會透過公費去做收入與支出，建議不要直接轉給墊錢的人，統一由公費管帳。透過公費領錢。\n
         2.最後帳目會以無條件進入法作結算，把誤差降到最低。\n
         3.在人物清單中，所有人員負債為零時，才是帳務結清。\n
         4.若採買中，還有區分分攤人員，建議拆出來做人員分攤。（例如酒類或是額外添購）\n
         5.結清賬務後，若要繼續記帳，建議另開帳本作下次公費計算。(因為明細會持續存在)\n
        """
    }

    @IBAction func ok(_ sender: Any) {
        dismiss(animated: true)
    }
}
