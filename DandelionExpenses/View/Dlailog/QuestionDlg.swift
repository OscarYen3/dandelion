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

        lblInfo.text = "本帳本計算方式為所有人會透過公費去做收入與支出，建議不要直接轉給墊錢的人，統一由公費管帳。透過公費領錢。\n\n 最後帳目會以無條件進入法作結算，把誤差降到最低。"
    }

    @IBAction func ok(_ sender: Any) {
        dismiss(animated: true)
    }
}
