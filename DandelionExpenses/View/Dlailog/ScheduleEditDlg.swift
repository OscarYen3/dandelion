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


class ScheduleEditDlg: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtEvent: UITextView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var textView: UIView!
    
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
    
    //=========================================================================
    // MARK: - txtNote Listener
    //=========================================================================
    func textViewDidBeginEditing(_ textView: UITextView) {
       
        if txtNote.textColor == UIColor.lightGray {
            txtNote.placeholder = nil
            txtNote.textColor = UIColor.black
        
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        if textView.text.count == 0 {
            txtNote.placeholder = NSLocalizedString("note", comment: "")
        }
        else {
            txtNote.placeholder =  ""
            
            
        }
        textView.borderColor = UIColor.lightGray
        textView.borderWidth = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            txtNote.resignFirstResponder()
//            return false
//        }
        return true
    }

}
