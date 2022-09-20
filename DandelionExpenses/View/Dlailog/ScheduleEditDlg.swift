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
    let formatter = DateFormatter()
    var selectDateView = UIDatePicker()
    let dateToolBar = UIToolbar()
    var dateText: Date? = Date()
    
    var detailData: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectDateView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        selectDateView.backgroundColor = UIColor.white
        selectDateView.datePickerMode = .date
        selectDateView.preferredDatePickerStyle = .inline
        selectDateView.date = NSDate() as Date
        formatter.dateFormat = "yyyy-MM-dd"
        let datenow = formatter.string(from: selectDateView.date)
        let endDateTime = formatter.date(from: datenow)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        selectDateView.minimumDate = endDateTime
        dateToolBar.barStyle = UIBarStyle.default
        dateToolBar.isTranslucent = true
        dateToolBar.tintColor = .systemBlue
        dateToolBar.sizeToFit()
        let birthDoneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneClick))
        let birthCancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancelClick))
        dateToolBar.setItems([birthCancelButton, spaceButton, birthDoneButton], animated: true)
        dateToolBar.isUserInteractionEnabled = true
        txtDate.inputView = selectDateView
        txtDate.inputAccessoryView = dateToolBar
        selectDateView.addTarget(self,action:#selector(datePickerChanged),for: .valueChanged)
        
        
        txtEvent.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = titleName
        if txtEvent.text == "" {
            let date = dateText ?? Date()
            txtDate.text = formatter.string(from: date)
        }
        
        txtEvent.text = detailData?.event
        txtNote.text =  detailData?.note
        txtDate.text =  formatter.string(from: detailData?.date ?? Date())
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
            if dataCheck() {
                if titleName == "新增行程" {
                    data.scheduleCode = Int(timeInterval)
                    data.date = dateText ?? Date()
                    data.event = txtEvent.text ?? ""
                    data.note = txtNote.text ?? ""
                    self._delegate?.newScheduleOk(scheduleProfile: data)
                } else if titleName == "編輯行程"  {
                    data.scheduleCode = userCodeValue
                    data.event = txtEvent.text ?? ""
                    data.note = txtNote.text ?? ""
                    data.scheduleId = detailData?.scheduleId ?? ""
                    data.sort = detailData?.sort ?? 0
                    self._delegate?.editScheduleOk(scheduleProfile: data)
                }
                
            } else {
                self.view.showToast(toastMessage: "事件不能為空", duration: 2)
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
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        txtEvent.text =  textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            txtNote.resignFirstResponder()
//            return false
//        }
        return true
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        datePicker.timeZone = TimeZone(abbreviation:"UTC")
        dateText = datePicker.date
    }
    
    @objc func doneClick()  {
        let date = dateText ?? Date()
        txtDate.text = formatter.string(from: date)
        self.view.endEditing(true)
    }
    
    @objc func cancelClick()  {
        self.view.endEditing(true)
    }
    
    func dataCheck() -> Bool {
        var verify: Bool = false
        if  txtEvent.text != "" {
            verify = true
        }
        return verify
    }

}
