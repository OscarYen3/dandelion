//
//  SideMenuView.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/7/12.
//

import UIKit

protocol SlideMenuDelegate {
    func SideMenuItemSelectedAtIndex(_ index : Int)
}

class SideMenuView: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var _tblMenu: UITableView!
    @IBOutlet weak var _btnCloseMenu: UIButton!
    
    @IBOutlet weak var lblAccount: UILabel!
    var _delegate : SlideMenuDelegate?
    var _btnMenu : UIButton!
    var displayLabel = ["聯絡我"]
    var mDataSource: [Dictionary<String, String>] = [Dictionary<String, String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        _tblMenu.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        _tblMenu.delegate = self
        _tblMenu.dataSource = self
        _tblMenu.tableFooterView = UIView()
        _btnCloseMenu.addTarget(self, action: #selector(OnCloseMenuClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblAccount.text = UserDefaults.Account
    }
    
    @objc func OnCloseMenuClicked() {
        print("OnCloseMenuClicked")
//        _btnMenu!.tag = 0
        
//        if (self._delegate != nil) {
//            var index = Int(button.tag)
//            if(button == self._btnCloseMenu) {
//                index = -1
//            }
            
            self.dismiss(animated: true, completion: {
                self._delegate?.SideMenuItemSelectedAtIndex(-1)
            })
        }
    

func OnCloseMenuwithztable(_ tag:Int) {
    print("OnCloseMenuClicked")
        self.dismiss(animated: true, completion: {
            self._delegate?.SideMenuItemSelectedAtIndex(tag)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Cell Selected \(indexPath.row) ")
//        let btn = UIButton(type: UIButton.ButtonType.custom)
        
        self.OnCloseMenuwithztable(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Common.xib_cellMenu)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell",for: indexPath) as! SideMenuCell
        cell.textLabel?.text = displayLabel[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayLabel.count
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
