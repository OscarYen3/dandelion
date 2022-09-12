//
//  ScheduleEditDlg.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/12.
//

import UIKit

protocol ScheduleEditDlgDelegate {
    func editScheduleCancel()
    func editScheduleOk()
}


class ScheduleEditDlg: UIViewController, UITextViewDelegate, NSTextStorageDelegate {

    @IBOutlet weak var txtEvent: UITextView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    var _delegate: ScheduleEditDlgDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEvent.delegate = self
    }

    @IBAction func btnClick(_ sender: UIButton) {
        
        switch sender {
        case btnCancel:
            _delegate?.editScheduleCancel()
            
            break
        case btnOk:
            _delegate?.editScheduleOk()
           
            break
            
        default:
            
            break
        }
    }

}
