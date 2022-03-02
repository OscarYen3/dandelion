//
//  AddMemberDlg.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/15.
//

import UIKit

protocol AddMemberDlgDlgDelegate{
    func OnCancel()
    func OnOK(_ name:String)
}

var memberArray:[Any] = []

class AddMemberDlg: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    var _delegate : AddMemberDlgDlgDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func cancelClcik(_ sender: Any) {
        _delegate?.OnCancel()
    }
    
    @IBAction func okClick(_ sender: Any) {
        if txtName.text != "" {
            memberArray = defaults.array(forKey: "NameList") ?? []
            memberArray.append(txtName.text ?? "")
            defaults.set(memberArray, forKey: "NameList")
        }
        _delegate?.OnOK(txtName.text ?? "")
    }
}
