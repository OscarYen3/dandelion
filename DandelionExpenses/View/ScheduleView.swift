//
//  ScheduleView.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import UIKit

class ScheduleView: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var _tblMenu: UITableView!
    
    var scheduledata : [Schedule] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tblMenu.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
      
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Common.xib_cellMenu)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell",for: indexPath) as! ScheduleCell
        
        return cell
    }

}
