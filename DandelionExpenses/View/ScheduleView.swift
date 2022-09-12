//
//  ScheduleView.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import UIKit




class ScheduleView: UIViewController,UITableViewDataSource, UITableViewDelegate,ScheduleEditDlgDelegate {
    
    
    
    
    @IBOutlet weak var _tblMenu: UITableView!
    
    @IBOutlet weak var btnEdit: UIButton!
    var scheduledata : [Schedule] =  []
    var m_oScheduleEditDlg : ScheduleEditDlg!
    
    var testData1: Schedule =  Schedule()
    var testData2: Schedule =  Schedule()
    var testData3: Schedule =  Schedule()
    var testData4: Schedule =  Schedule()
    var testData5: Schedule =  Schedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_oScheduleEditDlg = ScheduleEditDlg(nibName: Common.xib_ScheduleEditDlg, bundle: nil)
        _tblMenu.register(UINib(nibName: Common.xib_ScheduleCell, bundle: nil), forCellReuseIdentifier: Common.xib_ScheduleCell)
        
        testData1.note = "A"
        testData2.note = "B"
        testData3.note = "C"
        testData4.note = "D"
        testData5.note = "E"
        scheduledata.append(testData1)
        scheduledata.append(testData2)
        scheduledata.append(testData3)
        scheduledata.append(testData4)
        scheduledata.append(testData5)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_ScheduleCell,for: indexPath) as! ScheduleCell
        
        cell.lblIndex.text = "\(indexPath.row)"
        cell.lblEvent.text = "測試規劃"
        cell.lblNote.text = scheduledata[indexPath.row].note
        
        
        cell.topline.isHidden = indexPath.row == 0 ? true : false
        cell.bottomLine.isHidden = (indexPath.row + 1) == scheduledata.count ? true : false
        //        cell.bottomLine.isHidden = (indexPath.row + 1) == 5 ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIShowEditInfo(true)
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
            let itemValue:Schedule = scheduledata[sourceIndexPath.row]
            //删除移动的值
            scheduledata.remove(at: sourceIndexPath.row)
            //如果移动区域大于现有行数，直接在最后添加移动的值
            if destinationIndexPath.row > scheduledata.count{
                scheduledata.append(itemValue)
            } else{
                //没有超过最大行数，则在目标位置添加刚才删除的值
                scheduledata.insert(itemValue, at:destinationIndexPath.row)
            }
        }
        
        _tblMenu.reloadData()
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

            self.scheduledata.remove(at: index.row)
            self._tblMenu.reloadData()
        }
        return [deleteAction]
    }
    
    func UIShowEditInfo(_ bShow: Bool) {
        if let oView = m_oScheduleEditDlg {
            oView._delegate = self
            DialogShow(oView, bShow)
        }
    }
    
    func editScheduleCancel() {
        UIShowEditInfo(false)
    }
    
    func editScheduleOk() {
        UIShowEditInfo(false)
    }
    
    @IBAction func editClick(_ sender: Any) {
        _tblMenu.isEditing = !_tblMenu.isEditing
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

