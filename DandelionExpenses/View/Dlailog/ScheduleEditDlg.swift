//
//  ScheduleEditDlg.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/12.
//

import UIKit

protocol ScheduleEditDlgDelegate {
    func editScheduleCancel()
    func editScheduleOk(scheduleProfile:Schedule)
    func newScheduleOk(scheduleProfile:Schedule)
}


class ScheduleEditDlg: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtEvent: UITextView!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    var _delegate: ScheduleEditDlgDelegate?
    var titleName : String = ""
    var userCodeValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEvent.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = titleName
    }

    @IBAction func btnClick(_ sender: UIButton) {
        let data = Schedule()
        data.date = Date()
        let timeInterval = data.date.timeIntervalSince1970

        switch sender {
        case btnCancel:
            _delegate?.editScheduleCancel()
            
            break
        case btnOk:
            
            
            if titleName == "新增行程" {
                data.scheduleCode = Int(timeInterval)
                self._delegate?.newScheduleOk(scheduleProfile: data)
            } else if titleName == "編輯行程"  {
                data.scheduleCode = userCodeValue
                self._delegate?.editScheduleOk(scheduleProfile: data)
            }
           
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
