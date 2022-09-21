//
//  ScheduleView.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import UIKit
import Firebase
import FirebaseFirestore
import Network
import CoreData


class ScheduleView: UIViewController,UITableViewDataSource, UITableViewDelegate,ScheduleEditDlgDelegate {
    
    @IBOutlet weak var _tblList: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    
    var scheduleData: [Schedule] =  []
    var showSchedule: [Schedule] =  []
    var m_oScheduleEditDlg: ScheduleEditDlg!
    let formatter = DateFormatter()
    var selectDateView = UIDatePicker()
    let dateToolBar = UIToolbar()
    var dateText: Date? = Date()
    var addScheduleItem = UIBarButtonItem()
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_oScheduleEditDlg = ScheduleEditDlg(nibName: Common.xib_ScheduleEditDlg, bundle: nil)
        _tblList.register(UINib(nibName: Common.xib_ScheduleCell, bundle: nil), forCellReuseIdentifier: Common.xib_ScheduleCell)
        
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
        
        addScheduleItem = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: .plain, target: self, action: #selector(addScheduleClick))
        self.navigationItem.rightBarButtonItem = addScheduleItem
        self.btnEdit.isHidden = true
        readData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let date = dateText ?? Date()
        txtDate.text = formatter.string(from: date)
    }
    
    @objc func addScheduleClick() {
        UIShowEditInfo(true,edit: false,code: 0, detail: Schedule())
    }
    
    @objc func doneClick()  {
        let date = dateText ?? Date()
        txtDate.text = formatter.string(from: date)
        self.view.endEditing(true)
        
        showSchedule = filterSchedule()
        _tblList.reloadData()
    }
    
    @objc func cancelClick()  {
        self.view.endEditing(true)
        
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        datePicker.timeZone = TimeZone(abbreviation:"UTC")
        dateText = datePicker.date
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_ScheduleCell,for: indexPath) as! ScheduleCell
        
        cell.lblIndex.text = "\(showSchedule[indexPath.row].sort)"
        cell.lblEvent.text =  showSchedule[indexPath.row].event == "" ? " " : showSchedule[indexPath.row].event
        cell.lblNote.text = showSchedule[indexPath.row].note == "" ? " " : showSchedule[indexPath.row].note
        
        
        cell.topline.isHidden = indexPath.row == 0 ? true : false
        cell.bottomLine.isHidden = (indexPath.row + 1) == showSchedule.count ? true : false
        //        cell.bottomLine.isHidden = (indexPath.row + 1) == 5 ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIShowEditInfo(true,edit: true, code: showSchedule[indexPath.row].scheduleCode , detail: showSchedule[indexPath.row] )
        
    }
    
    // 設置 cell 是否允許移動
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // 移動 cell 時觸發
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 移動cell之後更換數據數組裏的循序
        if sourceIndexPath != destinationIndexPath{
            //获取移动行对应的值
            let itemValue:Schedule = showSchedule[sourceIndexPath.row]
            //删除移动的值
            showSchedule.remove(at: sourceIndexPath.row)
            //如果移动区域大于现有行数，直接在最后添加移动的值
            if destinationIndexPath.row > showSchedule.count{
                showSchedule.append(itemValue)
            } else{
                //没有超过最大行数，则在目标位置添加刚才删除的值
                showSchedule.insert(itemValue, at:destinationIndexPath.row)
            }
        }
        for (index, _) in self.showSchedule.enumerated() {
            self.showSchedule[index].sort = index + 1
        }
//        self.showSchedule = self.filterSchedule()
        
        _tblList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //            if _tblMenu.isEditing {
        //                return .none
        //            } else {
        return .delete
        //            }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") {
            action, index in
            self.deleteScheduleDocument(self.showSchedule[indexPath.row].scheduleId)
            self.showSchedule.remove(at: index.row)
            
            
            
            for (index, _) in self.showSchedule.enumerated() {
                self.showSchedule[index].sort = index + 1
                self.updateSchedule(self.showSchedule[index].scheduleCode, self.showSchedule[index])
                updateScheduleObject(self.showSchedule[index])
            }
            
            self.readData()
        }
        return [deleteAction]
    }
    
    func UIShowEditInfo(_ bShow: Bool,edit: Bool, code: Int, detail: Schedule) {
        if let oView = m_oScheduleEditDlg {
            oView._delegate = self
            oView.titleName = edit ? "編輯行程" : "新增行程"
            oView.userCodeValue  = code
            
            oView.detailData =  edit ? detail : Schedule()
            DialogShow(oView, bShow)
        }
    }
    
    func editScheduleCancel() {
        UIShowEditInfo(false,edit: true,code: 0, detail: Schedule())
    }
    
    func editScheduleOk(scheduleProfile: Schedule) {
        UIShowEditInfo(false,edit: true,code: 0, detail: Schedule())
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路則無法新增" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            for (index,value) in scheduleData.enumerated() {
                if value.scheduleId == scheduleProfile.scheduleId {
                    scheduleData[index] = scheduleProfile
                }
            }
            updateSchedule(scheduleProfile.scheduleCode, scheduleProfile)
            self.showSchedule = self.filterSchedule()
           
            _tblList.reloadData()
        }
        
    }
    
    func newScheduleOk(scheduleProfile: Schedule) {
        UIShowEditInfo(false,edit: true,code: 0, detail: Schedule())
        if !netWork {
            let controller = UIAlertController(title: "請檢查網路", message: "沒有網路則無法新增" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        } else {
            let filtercount = updatefilterSchedule(date: scheduleProfile.date)
            scheduleProfile.sort = filtercount.count + 1
            scheduleData.append(scheduleProfile)
//            scheduleData.insert(scheduleProfile, at: scheduleData.count - 1)
            addSchedule(scheduleProfile)
            readData()
        }
    }
    
    @IBAction func editClick(_ sender: Any) {
        _tblList.isEditing = !_tblList.isEditing
        if _tblList.isEditing  {
            btnEdit.setTitle("編輯完成", for: .normal)
        } else {
            btnEdit.setTitle("編輯", for: .normal)
            for (index, _) in self.showSchedule.enumerated() {
                self.showSchedule[index].sort = index + 1
                updateSchedule(self.showSchedule[index].scheduleCode, self.showSchedule[index])
                updateScheduleObject(self.showSchedule[index])
            }
        }
        _tblList.reloadData()
    }
    
    func addSchedule(_ profile: Schedule) {
        _ = db.collection(String(format: "%@%@",UserDefaults.Account ?? Common.collection2,"Schedule")).addDocument(data: [
            "scheduleCode": profile.scheduleCode,
            "sort": profile.sort,
            "date": profile.date,
            "event": profile.event,
            "note": profile.note
        ]) { (error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    func updateSchedule(_ target: Int, _ data: Schedule) {
        db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Schedule")).whereField("scheduleCode", isEqualTo: target).getDocuments() { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                let document = querySnapshot.documents.first
                document?.reference.updateData(["sort":data.sort])
                document?.reference.updateData(["date":data.date])
                document?.reference.updateData(["event":data.event])
                document?.reference.updateData(["note":data.note] ,completion: { (error) in })
            }
        }
    }
    
    func deleteScheduleDocument(_ target: String?) {
        guard let newTarget = target else { return }
        db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Schedule")).document(newTarget).delete() { err   in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    func readData() {
        if UserDefaults.Account == "" {
            UserDefaults.Account = Common.collection2
        }
        self.db.collection(String(format: "%@%@", UserDefaults.Account ?? Common.collection2,"Schedule") ).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                deleteScheduleAllObject(selectScheduleObject())
                for document in querySnapshot.documents {
                    print(document.data())
                    
                    self.scheduleConvert(target: document)
                }
            }
            self.scheduleData = selectScheduleObject()
            self.showSchedule = self.filterSchedule()
            self._tblList.reloadData()
        }
    }
    
    func scheduleConvert(target: QueryDocumentSnapshot){
        let data: Schedule = Schedule()
        for i in target.data() {
            switch i.key {
            case "date":
                formatter.dateFormat = "yyyy-MM-dd"
                let abc = i.value as! Timestamp
                let bbbb = abc.dateValue()
                data.date = bbbb
            case "event":
                data.event = i.value as! String
            case "note":
                data.note = i.value as! String
            case "sort":
                data.sort = i.value as! Int
            case "scheduleCode":
                data.scheduleCode = i.value as! Int
            default:
                break
            }
            
        }
        data.scheduleId = target.documentID
        insertScheduleObject(Schedule(data))
        
    }
    
    func filterSchedule() -> [Schedule] {
        
        showSchedule = []
        for i in scheduleData {
            self.formatter.timeZone = TimeZone(abbreviation: "UTC")
            let abc = formatter.string(from: i.date)
            let def = formatter.string(from: dateText ?? Date())
            if formatter.date(from: abc) == formatter.date(from: def) {
                showSchedule.append(i)
            }
        }
        
        self.btnEdit.isHidden = showSchedule.count == 0 ? true : false
        return showSchedule
    }
    
    func updatefilterSchedule(date: Date) -> [Schedule] {
        
        var filterSchedule : [Schedule] = []
        for i in scheduleData {
            self.formatter.timeZone = TimeZone(abbreviation: "UTC")
            let abc = formatter.string(from: i.date)
            let def = formatter.string(from: date)
            if formatter.date(from: abc) == formatter.date(from: def) {
                filterSchedule.append(i)
            }
        }
        return filterSchedule
    }
    
    
    
    private func DialogShow(_ oView: UIViewController , _ bShow:Bool) {
        
        if(bShow) {
            oView.modalPresentationStyle = .fullScreen
            oView.modalPresentationStyle = .custom
            self.present(oView, animated: true, completion: nil)
            oView.view.center = oView.view.center
            
            oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            oView.view.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                oView.view.alpha = 1
                oView.view.transform = CGAffineTransform.identity
            }
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                oView.view.alpha = 0
            }) { (success:Bool) in
                oView.dismiss(animated: true)
                
            }
        }
        
    }
}

