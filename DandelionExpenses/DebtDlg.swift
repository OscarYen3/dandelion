//
//  DebtDlg.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/8/9.
//

import UIKit

protocol DebtDlgDelegate{
    func DebtOnOk()
}

class DebtDlg: UIViewController {
    var _delegate : DebtDlgDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancelClcik(_ sender: Any) {
        _delegate?.DebtOnOk()
    }

}
