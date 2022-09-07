//
//  ScheduleCell.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var index = ""
    var event = ""
    var time = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblIndex.text = index
        lblEvent.text = event
        lblTime.text = time
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
