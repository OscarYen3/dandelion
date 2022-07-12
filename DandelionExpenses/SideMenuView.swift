//
//  SideMenuView.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/7/12.
//

import UIKit

protocol SlideMenuDelegate {
    func SideMenuItemSelectedAtIndex(_ index : Int)
    func SideMenuMemberBtnClick(_ title: String, _ status: String,_ path: String)
    func SideMenuLogout()
    func CheckDataUpload()
}

class SideMenuView: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var _tblMenu: UITableView!
    @IBOutlet weak var _btnCloseMenu: UIButton!
    
    var _delegate : SlideMenuDelegate?
    var _btnMenu : UIButton!
    var displayLabel = ["NO.1","NO.2"]
    var mDataSource: [Dictionary<String, String>] = [Dictionary<String, String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tblMenu.delegate = self
        _tblMenu.dataSource = self
        _tblMenu.tableFooterView = UIView()
    }
    
    @IBAction func OnCloseMenuClicked(_ button: UIButton!) {
        print("OnCloseMenuClicked")
        _btnMenu!.tag = 0
        
        if (self._delegate != nil) {
            var index = Int(button.tag)
            if(button == self._btnCloseMenu) {
                index = -1
            }
            
            self.dismiss(animated: true, completion: {
                self._delegate?.SideMenuItemSelectedAtIndex(index)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Cell Selected \(indexPath.row) ")
        let btn = UIButton(type: UIButton.ButtonType.custom)
        
        self.OnCloseMenuClicked(btn)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Common.xib_cellMenu)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu",for: indexPath) as! SideMenuCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayLabel[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 12)
        header.textLabel?.textColor = UIColor.gray
        header.tintColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40
    }
    
    
}
